// mobile/ios/Yoliva/Features/TripDetail/BookingConfirmationSheet.swift
import SwiftUI

/// Native Bottom Sheet for confirming the booking.
struct BookingConfirmationSheet: View {
    @ObservedObject var viewModel: TripDetailViewModel
    let accentColor: Color
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 25) {
            if viewModel.isBookingSuccess {
                // Success State with Animation
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(accentColor)
                        .scaleEffect(1.2)
                        .transition(.scale.combined(with: .opacity))
                    
                    Text("Rezervasyon Başarılı!")
                        .font(AppTheme.Typography.title(24))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 4) {
                        Text("PNR Kodu")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(viewModel.pnrCode ?? "")
                            .font(AppTheme.Typography.numeric(28))
                            .foregroundColor(accentColor)
                    }
                    .padding(20)
                    .glassCard(cornerRadius: 20)
                    
                    YolivaPrimaryButton(
                        title: "Bileti Görüntüle",
                        isPink: accentColor == AppTheme.yolivaPink,
                        action: {
                            dismiss()
                            // Logic to navigate to Ticket detail or My Rides
                        }
                    )
                    .padding(.top, 10)
                }
                .padding(30)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                // Summary State
                VStack(alignment: .leading, spacing: 20) {
                    Text("Rezervasyon Özeti")
                        .font(AppTheme.Typography.title(22))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        SummaryRow(icon: "mappin.and.ellipse", label: "Rota", value: "\(viewModel.trip?.fromCity ?? "") ➔ \(viewModel.trip?.toCity ?? "")")
                        SummaryRow(icon: "calendar", label: "Tarih", value: viewModel.trip?.departureTime ?? Date(), isDate: true)
                        SummaryRow(icon: "banknote", label: "Toplam Ücret", value: "₺\(Int(viewModel.trip?.price ?? 0.0))")
                    }
                    .padding(20)
                    .glassCard(cornerRadius: 20)
                    
                    YolivaPrimaryButton(
                        title: "Onayla",
                        isLoading: viewModel.bookingLoading,
                        isPink: accentColor == AppTheme.yolivaPink,
                        action: {
                            Task {
                                await viewModel.confirmBooking()
                            }
                        }
                    )
                    
                    Text("Onaylayarak Yoliva kullanım koşullarını kabul etmiş olursunuz.")
                        .font(.system(size: 10))
                        .foregroundColor(.gray.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding(30)
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.7), value: viewModel.isBookingSuccess)
        .animation(.spring(), value: viewModel.bookingLoading)
    }
}

struct SummaryRow: View {
    let icon: String
    let label: String
    var value: Any
    var isDate: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            
            if isDate, let dateValue = value as? Date {
                Text(dateValue, style: .date)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            } else if let stringValue = value as? String {
                Text(stringValue)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
        }
    }
}
