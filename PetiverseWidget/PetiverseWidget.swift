//
//  PetiverseWidget.swift
//  PetiverseWidget
//
//  Created by Enes Talha Uçar on 13.04.2025.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct PetiverseWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("logoPetiverse")
                    .resizable()
                    .frame(width: 30, height: 30)

                Text("Petiverse")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("1. Widget'a uzun basın").font(.system(size: 10, weight: .regular))
                Text("2. Widgeti düzenlemek için üzerine dokunun")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 10, weight: .regular))
                Text("3. Widgetinizi listeden seçin").font(.system(size: 10, weight: .regular)).fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}

struct PetiverseWidget: Widget {
    let kind: String = "PetiverseWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PetiverseWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    PetiverseWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
