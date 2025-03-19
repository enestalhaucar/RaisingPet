//
//  AppIntent.swift
//  PetiverseWidgetExtension
//
//  Created by Enes Talha Uçar  on 30.09.2024.
//
import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select a Widget"
    static var description = IntentDescription("Choose a widget from your saved collection.")
    
    @Parameter(title: "Saved Widgets", default: nil)
    var selectedWidgetId: String?
    
    static var parameterSummary: some ParameterSummary {
        Summary("Select a widget: \(\.$selectedWidgetId)")
    }
}

// Widget seçeneklerini sağlamak için bir Entity tanımlıyoruz
struct WidgetEntity: AppEntity {
    let id: String
    let title: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Widget"
    static var defaultQuery = WidgetEntityQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: title))
    }
}

struct WidgetEntityQuery: EntityQuery {
    func entities(for identifiers: [WidgetEntity.ID]) async throws -> [WidgetEntity] {
        guard let userDefaults = UserDefaults(suiteName: "group.com.petiverse.widgets"),
              let data = userDefaults.data(forKey: "savedWidgets"),
              let widgets = try? JSONDecoder().decode([PetiverseWidgetItem].self, from: data) else {
            return []
        }
        
        return widgets
            .filter { identifiers.contains($0.id.uuidString) }
            .map { WidgetEntity(id: $0.id.uuidString, title: $0.title) }
    }
    
    func suggestedEntities() async throws -> [WidgetEntity] {
        guard let userDefaults = UserDefaults(suiteName: "group.com.petiverse.widgets"),
              let data = userDefaults.data(forKey: "savedWidgets"),
              let widgets = try? JSONDecoder().decode([PetiverseWidgetItem].self, from: data) else {
            return []
        }
        
        return widgets.map { WidgetEntity(id: $0.id.uuidString, title: $0.title) }
    }
    
    func defaultResult() async -> WidgetEntity? {
        try? await suggestedEntities().first
    }
}
