import SwiftUI

struct AddJournalView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddJournalViewModel

    var onSave: (String, String) -> Void

    private let accentColor = Color(red: 127/255, green: 129/255, blue: 255/255) // #7F81FF
    private let placeholderColor = Color(white: 0.35) // رمادي خفيف

    init(
        journal: Journal? = nil,
        onSave: @escaping (String, String) -> Void
    ) {
        self.onSave = onSave
        _viewModel = StateObject(
            wrappedValue: AddJournalViewModel(journal: journal)
        )
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // Title (placeholder رمادي خفيف، النص أبيض)
                TextField(
                    "",
                    text: $viewModel.title,
                    prompt: Text("Title").foregroundColor(placeholderColor)
                )
                .font(.title2.bold())
                .foregroundStyle(.white)
                .tint(accentColor)
                .textFieldStyle(.plain)

                // Date
                Text(viewModel.displayDate, style: .date)
                    .font(.caption)
                    .foregroundStyle(Color("secondary"))
                    .padding(.top, 4)

                // Divider
                Rectangle()
                    .fill(Color(red: 0.30, green: 0.30, blue: 0.32))
                    .frame(height: 1)

                // Journal Content
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.content)
                        .font(.body)
                        .foregroundStyle(.white)
                        .tint(accentColor)
                        .scrollContentBackground(.hidden)
                        .background(Color.black)

                    if viewModel.content.isEmpty {
                        Text("Type your journal...")
                            .font(.body)
                            .foregroundStyle(placeholderColor)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                // Cancel (دائرة غامقة + X أبيض)
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if viewModel.hasChanges {
                            viewModel.showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .clipShape(Circle())
                    }
                }

                // Save (دائرة بنفسجية + checkmark غامق)
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        guard viewModel.canSave else { return }
                        onSave(viewModel.title, viewModel.content)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(width: 44, height: 44)
                            .background(accentColor)
                            .clipShape(Circle())
                            .opacity(viewModel.canSave ? 1 : 0.4)
                    }
                    .disabled(!viewModel.canSave)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert("Discard Changes?", isPresented: $viewModel.showDiscardAlert) {
                Button("Keep Editing", role: .cancel) { }
                Button("Discard Changes", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to discard your changes?")
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AddJournalView { _, _ in }
}
