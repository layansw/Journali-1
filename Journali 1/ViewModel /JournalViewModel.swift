import SwiftUI
import Combine

final class JournalViewModel: ObservableObject {

    // MARK: - Data
    @Published var journals: [Journal] = []
    @Published var searchText = ""
    @Published var sortByBookmark = false

    // MARK: - UI State
    @Published var showEditor = false
    @Published var editingJournal: Journal?
    @Published var journalToDelete: Journal?
    @Published var showDeleteAlert = false

    // MARK: - Derived
    var filteredJournals: [Journal] {
        var result = journals

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        if sortByBookmark {
            result.sort {
                if $0.isBookmarked != $1.isBookmarked {
                    return $0.isBookmarked
                }
                return $0.date > $1.date
            }
        } else {
            result.sort { $0.date > $1.date }
        }
        return result
    }

    // MARK: - Editor Actions
    func startAdding() {
        editingJournal = nil
        showEditor = true
    }

    func startEditing(_ journal: Journal) {
        editingJournal = journal
        showEditor = true
    }

    func saveJournal(title: String, content: String) {
        if let journal = editingJournal {
            updateJournal(journal, title: title, content: content)
        } else {
            addJournal(title: title, content: content)
        }
    }

    // MARK: - Delete Actions
    func requestDelete(_ journal: Journal) {
        journalToDelete = journal
        showDeleteAlert = true
    }

    func confirmDelete() {
        if let journal = journalToDelete {
            deleteJournal(journal)
        }
        journalToDelete = nil
    }

    func cancelDelete() {
        journalToDelete = nil
    }

    // MARK: - CRUD
    func addJournal(title: String, content: String) {
        journals.append(Journal(title: title, content: content))
    }

    func updateJournal(_ journal: Journal, title: String, content: String) {
        guard let index = journals.firstIndex(where: { $0.id == journal.id }) else { return }
        journals[index].title = title
        journals[index].content = content
    }

    func deleteJournal(_ journal: Journal) {
        journals.removeAll { $0.id == journal.id }
    }

    func toggleBookmark(_ journal: Journal) {
        guard let index = journals.firstIndex(where: { $0.id == journal.id }) else { return }
        journals[index].isBookmarked.toggle()
    }
}
