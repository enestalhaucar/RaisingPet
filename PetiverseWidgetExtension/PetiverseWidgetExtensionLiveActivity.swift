//
//  PetiverseWidgetExtensionLiveActivity.swift
//  PetiverseWidgetExtension
//
//  Created by Enes Talha Uçar  on 30.09.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PetiverseWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PetiverseWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PetiverseWidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PetiverseWidgetExtensionAttributes {
    fileprivate static var preview: PetiverseWidgetExtensionAttributes {
        PetiverseWidgetExtensionAttributes(name: "World")
    }
}

extension PetiverseWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: PetiverseWidgetExtensionAttributes.ContentState {
        PetiverseWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PetiverseWidgetExtensionAttributes.ContentState {
         PetiverseWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PetiverseWidgetExtensionAttributes.preview) {
   PetiverseWidgetExtensionLiveActivity()
} contentStates: {
    PetiverseWidgetExtensionAttributes.ContentState.smiley
    PetiverseWidgetExtensionAttributes.ContentState.starEyes
}
