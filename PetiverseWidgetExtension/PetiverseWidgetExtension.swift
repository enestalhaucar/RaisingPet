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
        SimpleEntry(countdown: CountDownWidget(targetDate: Date(), title: "Maldives"), date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(countdown: CountDownWidget(targetDate: Date(), title: "Maldives"), date: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minuteOffSet in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffSet, to: currentDate)!
            let entry = SimpleEntry(countdown: CountDownWidget(targetDate: Date(), title: "Maldives"), date: Date())
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let countdown : CountDownWidget
    let date: Date
    
    
}

struct PetiverseWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        CountDownView(title: entry.countdown.title, dayText: entry.countdown.dayRemaining.days, hourText: entry.countdown.dayRemaining.hour, minuteText: entry.countdown.dayRemaining.minutes, backgroundImage: Image("notesIcon"), backgroundImageSelected: false)
    }
}

struct PetiverseWidgetExtension: Widget {
    let kind: String = "PetiverseWidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PetiverseWidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.contentMarginsDisabled()
    }
}


#Preview(as: .systemMedium) {
    PetiverseWidgetExtension()
} timeline: {
    SimpleEntry(countdown: CountDownWidget(targetDate: Date(), title: "Maldives"), date: .now)
    SimpleEntry(countdown: CountDownWidget(targetDate: Date(), title: "Maldives"), date: .now)
}
