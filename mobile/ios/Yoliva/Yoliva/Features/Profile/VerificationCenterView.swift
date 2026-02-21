// mobile/ios/Yoliva/Features/Profile/VerificationCenterView.swift
import SwiftUI

struct VerificationCenterView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Header Info
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Doğrulama Merkezi")
                            .font(AppTheme.Typography.title(28))
                            .foregroundColor(.white)
                        Text("Güvenli bir yolculuk deneyimi için belgelerini tamamla. Doğrulanmış kullanıcılar 3 kat daha fazla tercih ediliyor.")
                            .font(AppTheme.Typography.body(15))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Verification Tiers
                    VStack(spacing: 16) {
                        VerificationRow(
                            title: "T.C. Kimlik",
                            subtitle: "Kimlik kartı veya Pasaport",
                            status: viewModel.idStatus,
                            icon: "person.text.rectangle.fill"
                        ) {
                            if viewModel.idStatus == .missing { viewModel.startVerification(for: "T.C. Kimlik") }
                        }
                        
                        VerificationRow(
                            title: "Sürücü Belgesi",
                            subtitle: "Aktif sürücü ehliyeti",
                            status: viewModel.licenseStatus,
                            icon: "card.fill"
                        ) {
                            if viewModel.licenseStatus == .missing { viewModel.startVerification(for: "Sürücü Belgesi") }
                        }
                        
                        VerificationRow(
                            title: "e-Devlet Sabıka Kaydı",
                            subtitle: "Son 6 ay içerisinde alınmış",
                            status: viewModel.criminalRecordStatus,
                            icon: "doc.text.fill"
                        ) {
                            if viewModel.criminalRecordStatus == .missing { viewModel.startVerification(for: "e-Devlet Sabıka Kaydı") }
                        }
                        
                        VerificationRow(
                            title: "Araç Ruhsatı",
                            subtitle: "Sürücüler için zorunludur",
                            status: viewModel.vehicleRegStatus,
                            icon: "car.fill"
                        ) {
                            if viewModel.vehicleRegStatus == .missing { viewModel.startVerification(for: "Araç Ruhsatı") }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Security Note
                    HStack(spacing: 12) {
                        Image(systemName: "shield.lefthalf.filled")
                            .foregroundColor(AppTheme.primary)
                        Text("Verileriniz 256-bit şifreleme ile korunmaktadır ve asla üçüncü şahıslarla paylaşılmaz.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(20)
                    .glassCard(cornerRadius: 20)
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationTitle("Güvenlik")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isTakingPhoto) {
            PhotoCaptureMockView(viewModel: viewModel)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

struct VerificationRow: View {
    let title: String
    let subtitle: String
    let status: VerificationStatus
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            AppTheme.haptic(.light)
            action()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Status Badge
                HStack(spacing: 4) {
                    if status == .approved {
                        Image(systemName: status.icon)
                    }
                    Text(status.rawValue)
                }
                .font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(status.color.opacity(0.1))
                .foregroundColor(status.color)
                .clipShape(Capsule())
            }
            .padding(18)
            .glassCard(cornerRadius: 20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PhotoCaptureMockView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var isUploading: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text(viewModel.selectedDocType ?? "Belge Yükle")
                    .font(AppTheme.Typography.title())
                    .foregroundColor(.white)
                
                // Mock Camera Frame
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(AppTheme.primary, style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .frame(height: 200)
                    
                    if isUploading {
                        VStack(spacing: 15) {
                            ProgressView()
                                .tint(AppTheme.primary)
                                .scaleEffect(1.5)
                            Text("Yükleniyor...")
                                .foregroundColor(.gray)
                        }
                    } else {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.2))
                    }
                }
                .padding(.horizontal, 40)
                
                if !isUploading {
                    YolivaPrimaryButton(title: "Fotoğraf Çek") {
                        AppTheme.haptic(.rigid)
                        withAnimation { isUploading = true }
                        Task {
                            await viewModel.completePhotoUpload()
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}
