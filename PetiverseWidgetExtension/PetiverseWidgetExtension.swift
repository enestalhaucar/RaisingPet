//
//  PetiverseWidgetExtension.swift
//  PetiverseWidgetExtension
//
//  Created by Enes Talha Uçar  on 30.09.2024.
//

import WidgetKit
import SwiftUI


struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), selectedWidget: nil)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let selectedWidget = loadSelectedWidget(from: configuration)
        return SimpleEntry(date: Date(), selectedWidget: selectedWidget)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let selectedWidget = loadSelectedWidget(from: configuration)
        let entry = SimpleEntry(date: Date(), selectedWidget: selectedWidget)
        
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    func loadSelectedWidget(from configuration: ConfigurationAppIntent) -> PetiverseWidgetItem? {
        guard let selectedWidgetId = configuration.selectedWidgetId,
              let uuid = UUID(uuidString: selectedWidgetId),
              let userDefaults = UserDefaults(suiteName: "group.com.petiverse.widgets"),
              let data = userDefaults.data(forKey: "savedWidgets"),
              let widgets = try? JSONDecoder().decode([PetiverseWidgetItem].self, from: data),
              let selectedWidget = widgets.first(where: { $0.id == uuid }) else {
            print("Seçili widget bulunamadı. ID: \(configuration.selectedWidgetId ?? "nil")")
            return nil
        }
        
        if let encoded = try? JSONEncoder().encode(selectedWidget) {
            userDefaults.set(encoded, forKey: "selectedWidget")
            print("Seçili widget kaydedildi: \(selectedWidget.title)")
        }
        return selectedWidget
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let selectedWidget: PetiverseWidgetItem?
}

struct PetiverseWidgetExtensionEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        if let widget = entry.selectedWidget {
            let backgroundColor = colorFromString(widget.backgroundColor)
            let textColor = colorFromString(widget.textColor)
            let timeRemaining = calculateTimeRemaining(from: widget.targetDate ?? Date())
            switch widget.type {
            case .countdown:
                if let targetDate = widget.targetDate,
                   let style = widget.countdownStyle {
                    let timeRemaining = calculateTimeRemaining(from: targetDate)
                    switch style {
                    case .style1:
                        CountdownWidgetPreviewDesignOne(item: widget, timeRemaining: timeRemaining, backgroundColor: backgroundColor, textColor: textColor)
                    case .style2:
                        CountdownWidgetPreviewDesignTwo(item: widget, timeRemaining: timeRemaining, backgroundColor: backgroundColor, textColor: textColor)
                    case .style3:
                        CountdownWidgetPreviewDesignThree(item: widget, timeRemaining: timeRemaining, backgroundColor: backgroundColor, textColor: textColor)
                    case .style4:
                        CountdownWidgetPreviewDesignFour(item: widget, timeRemaining: timeRemaining, backgroundColor: backgroundColor, textColor: textColor)
                    }
                }
            case .album, .distance, .draw:
                Text("Coming Soon: \(widget.type.rawValue)") // Diğer türler için placeholder
            }
        } else {
            Text("Uzun basın ve listeden widget seçin")
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
        }
    }
    func colorFromString(_ string: String) -> Color {
        switch string.lowercased() {
        case "blue": return .blue
        case "white": return .white
        case "red": return .red
        case "green": return .green
        case "gray": return .gray
        default: return .gray // Bilinmeyen renkler için varsayılan
        }
    }
    
    func calculateTimeRemaining(from targetDate: Date) -> (days: Int, hours: Int, minutes: Int) {
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: targetDate)
        return (
            days: components.day ?? 0,
            hours: components.hour ?? 0,
            minutes: components.minute ?? 0
        )
    }
}

struct PetiverseWidgetExtension: Widget {
    let kind: String = "PetiverseWidgetExtension"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PetiverseWidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
