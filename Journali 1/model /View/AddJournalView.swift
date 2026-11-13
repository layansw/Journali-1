
import SwiftUI

struct AddJournalView: View {
    @Environment(\.dismiss) private var dismiss

    var journal: Journal?
    var onSave: (String, String) -> Void

    @State private var title: String
    @State private var content: String
    @State private var showDiscardAlert = false

    init(
        journal: Journal? = nil,
        onSave: @escaping (String, String) -> Void
    ) {
        self.journal = journal
        self.onSave = onSave

        _title = State(initialValue: journal?.title ?? "")
        _content = State(initialValue: journal?.content ?? "")
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // Title

                TextField("Title", text: $title)
                    .font(.title2.bold())
                    .foregroundColor(Color("text"))
                    .tint(Color("text"))
                    .textFieldStyle(.plain)

                // Date

                Text(
                    journal?.date ?? Date(),
                    style: .date
                )
                .font(.caption)
                .foregroundColor(Color("secondary"))
                .padding(.top, 4)

                // Divider

                Rectangle()
                    .fill(
                        Color(
                            red: 0.30,
                            green: 0.30,
                            blue: 0.32
                        )
                    )
                    .frame(height: 1)

                // Journal Content

                ZStack(alignment: .topLeading) {

                    TextEditor(text: $content)
                        .font(.body)
                        .foregroundColor(.white)
                        .tint(Color("Primary"))
                        .scrollContentBackground(.hidden)
                        .background(Color.black)

                    if content.isEmpty {
                        Text("Type your journal...")
                            .font(.body)
                            .foregroundColor(Color("secondary"))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding(20)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background(Color.black.ignoresSafeArea())

            .navigationTitle(
                journal == nil ? "New Journal" : "Edit Journal"
            )
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                // Cancel Button

                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showDiscardAlert = true
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                // Save Checkmark Button

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onSave(title, content)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(
                                .system(
                                    size: 17,
                                    weight: .semibold
                                )
                            )
                            .foregroundColor(Color("Primary"))
                    }
                    .disabled(
                        title.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
            }

            .tint(Color("Primary"))

            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)

            .alert(
                "Discard Changes?",
                isPresented: $showDiscardAlert
            ) {
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

