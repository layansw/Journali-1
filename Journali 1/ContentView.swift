import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = JournalViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.journals.isEmpty {
                    emptyState
                } else if viewModel.filteredJournals.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
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
                        viewModel.startAdding()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $viewModel.showEditor) {
                AddJournalView(journal: viewModel.editingJournal) { title, content in
                    viewModel.saveJournal(title: title, content: content)
                }
                .presentationBackground(Color.black)
            }
            .alert("Delete Journal?", isPresented: $viewModel.showDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    viewModel.cancelDelete()
                }
                Button("Delete", role: .destructive) {
                    viewModel.confirmDelete()
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
                .foregroundStyle(Color("Primary"))

            Text("Craft your personal diary, tap the\nplus icon to begin.")
                .font(.body)
                .foregroundStyle(Color("secondary"))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Journal List

    private var journalList: some View {
        List {
            ForEach(viewModel.filteredJournals) { journal in
                journalCard(journal)
                    .listRowBackground(Color.black)
                    .listRowSeparator(.hidden)
                    .listRowInsets(
                        EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.requestDelete(journal)
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

    private func journalCard(_ journal: Journal) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                Text(journal.title)
                    .font(.title2.bold())
                    .foregroundStyle(Color(red: 175/255, green: 153/255, blue: 253/255)) // #AF99FD

                Spacer()

                Button {
                    viewModel.toggleBookmark(journal)
                } label: {
                    Image(systemName: journal.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(red: 127/255, green: 129/255, blue: 255/255)) // #7F81FF
                }
                .buttonStyle(.borderless)
            }

            Text(formattedDate(journal.date))
                .font(.subheadline)
                .foregroundStyle(Color("secondary"))

            Text(journal.content)
                .font(.body)
                .foregroundStyle(.white)
                .lineLimit(5)
                .padding(.top, 16)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.startEditing(journal)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color("secondary"))

            TextField("Search", text: $viewModel.searchText)
                .foregroundStyle(.white)
                .tint(Color("Primary"))
                .textFieldStyle(.plain)

            Image(systemName: "mic")
                .foregroundStyle(Color("secondary"))
        }
        .padding()
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .clipShape(Capsule())
        .padding()
        .background(Color.black)
    }
}

#Preview {
    ContentView()
}
