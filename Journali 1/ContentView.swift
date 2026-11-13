
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = JournalViewModel()

    @State private var showEditor = false
    @State private var editingJournal: Journal?

    @State private var journalToDelete: Journal?
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.journals.isEmpty {
                    emptyState
                } else if viewModel.filteredJournals.isEmpty {
                    ContentUnavailableView.search(
                        text: viewModel.searchText
                    )
                } else {
                    journalList
                }
            }
            .background(Color.black)
            .safeAreaInset(edge: .bottom) {
                searchBar
            }
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {

                    Menu {
                        Button("Sort by Bookmark") {
                            viewModel.sortByBookmark = true
                        }

                        Button("Sort by Entry Date") {
                            viewModel.sortByBookmark = false
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }

                    Button {
                        editingJournal = nil
                        showEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)

            // Add / Edit Journal

            .sheet(isPresented: $showEditor) {
                AddJournalView(journal: editingJournal) { title, content in

                    if let journal = editingJournal {
                        viewModel.updateJournal(
                            journal,
                            title: title,
                            content: content
                        )
                    } else {
                        viewModel.addJournal(
                            title: title,
                            content: content
                        )
                    }
                }
                .presentationBackground(Color.black)
            }

            // Delete Confirmation

            .alert(
                "Delete Journal?",
                isPresented: $showDeleteAlert
            ) {
                Button("Cancel", role: .cancel) {
                    journalToDelete = nil
                }

                Button("Delete", role: .destructive) {
                    if let journal = journalToDelete {
                        viewModel.deleteJournal(journal)
                    }

                    journalToDelete = nil
                }
            } message: {
                Text("Are you sure you want to delete this Journal?")
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(._2)
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            Text("Begin Your Journal")
                .font(.title2.bold())
                .foregroundColor(Color("Primary"))

            Text("Craft your personal diary, tap the\nplus icon to begin.")
                .font(.body)
                .foregroundColor(Color("secondary"))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Journal List

    private var journalList: some View {
        List {
            ForEach(viewModel.filteredJournals) { journal in

                VStack(alignment: .leading, spacing: 8) {

                    HStack {
                        Text(journal.title)
                            .font(.headline)
                            .foregroundColor(Color("text"))

                        Spacer()

                        Button {
                            viewModel.toggleBookmark(journal)
                        } label: {
                            Image(
                                systemName: journal.isBookmarked
                                ? "bookmark.fill"
                                : "bookmark"
                            )
                            .font(.system(size: 17))
                            .foregroundColor(Color("Primary"))
                        }
                        .buttonStyle(.borderless)
                    }

                    Text(journal.date, style: .date)
                        .font(.caption2)
                        .foregroundColor(Color("secondary"))

                    Text(journal.content)
                        .font(.body)
                        .foregroundColor(.white)
                        .lineLimit(4)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Color(
                        red: 0.11,
                        green: 0.11,
                        blue: 0.12
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    editingJournal = journal
                    showEditor = true
                }
                .listRowBackground(Color.black)
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(
                        top: 6,
                        leading: 16,
                        bottom: 6,
                        trailing: 16
                    )
                )
                .swipeActions(
                    edge: .trailing,
                    allowsFullSwipe: false
                ) {
                    Button(role: .destructive) {
                        journalToDelete = journal
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.black)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("secondary"))

            TextField(
                "Search",
                text: $viewModel.searchText
            )
            .foregroundColor(.white)
            .tint(Color("Primary"))
            .textFieldStyle(.plain)

            Image(systemName: "mic")
                .foregroundColor(Color("secondary"))
        }
        .padding()
        .background(
            Color(
                red: 0.11,
                green: 0.11,
                blue: 0.12
            )
        )
        .clipShape(Capsule())
        .padding()
        .background(Color.black)
    }
}

#Preview {
    ContentView()
}

