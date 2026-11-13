
import SwiftUI
import Combine

class JournalViewModel: ObservableObject {

    @Published var journals: [Journal] = []
    @Published var searchText = ""
    @Published var sortByBookmark = false

    var filteredJournals: [Journal] {

        var result = journals

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        if sortByBookmark {
            return result.sorted {
                if $0.isBookmarked != $1.isBookmarked {
                    return $0.isBookmarked
                }
                return $0.date > $1.date
            }
        }

        return result.sorted { $0.date > $1.date }
    }

    func addJournal(title: String, content: String) {
        let journal = Journal(
            title: title,
            content: content,
            date: Date()
        )

        journals.append(journal)
    }

    func updateJournal(_ journal: Journal, title: String, content: String) {
        guard let index = journals.firstIndex(where: { $0.id == journal.id }) else {
            return
        }

        journals[index].title = title
        journals[index].content = content
    }

    func deleteJournal(_ journal: Journal) {
        journals.removeAll { $0.id == journal.id }
    }

    func toggleBookmark(_ journal: Journal) {
        guard let index = journals.firstIndex(where: { $0.id == journal.id }) else {
            return
        }

        journals[index].isBookmarked.toggle()
    }
}

