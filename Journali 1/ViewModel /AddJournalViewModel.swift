import SwiftUI
import Combine

final class AddJournalViewModel: ObservableObject {

    @Published var title: String
    @Published var content: String
    @Published var showDiscardAlert = false

    private let journal: Journal?

    init(journal: Journal?) {
        self.journal = journal
        self.title = journal?.title ?? ""
        self.content = journal?.content ?? ""
    }

    var navigationTitle: String {
        journal == nil ? "New Journal" : "Edit Journal"
    }

    var displayDate: Date {
        journal?.date ?? Date()
    }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var hasChanges: Bool {
        title != (journal?.title ?? "") || content != (journal?.content ?? "")
    }
}
