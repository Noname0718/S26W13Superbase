import SwiftUI
import Supabase

struct Song: Identifiable, Decodable {
    let id: UUID
    let title: String
    let artist: String
    let rating: Int
    let lyrics: String
}

struct ContentView: View {
    @State private var songs: [Song] = []
    @State private var userEmail: String = "로그아웃 상태"

    var body: some View {
        VStack {
            HStack {
                Text(userEmail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("임꺽정 로그인") {
                    Task {
                        await signInAndFetch()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            .padding(.horizontal)

            List(songs) { song in
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.title)
                        .font(.headline)
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    func signInAndFetch() async {
        do {
            let session = try await SupabaseManager.client.auth.signIn(
                email: "kjlim@test.com",
                password: "pass123"
            )
            userEmail = session.user.email ?? ""
            await fetchSongs()
        } catch {
            print("로그인 에러: \(error)")
        }
    }

    func fetchSongs() async {
        do {
            songs = try await SupabaseManager.client
                .from("songs")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
        } catch {
            print("조회 에러: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
