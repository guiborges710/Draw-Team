import SwiftUI

struct Player: Identifiable {
    let id = UUID()
    let name: String
}

struct Team: Identifiable {
    let id = UUID()
    let name: String
    let players: [Player]
}

struct ContentView: View {
    @State private var playerName = ""
    @State private var players = [Player(name: "Borges"), Player(name: "Cadito"), Player(name: "Wata"),Player(name: "Lilo"), Player(name: "Ken"), Player(name: "Ryu"),Player(name: "Matsuba"), Player(name: "Rod"), Player(name: "Pedrinho"), Player(name: "Lucas"), Player(name: "Vini"), Player(name: "Gutao"), Player(name: "Thomaz")]
    @State private var teams = [Team]()
    @State private var showPlayersList = true
    @State private var hasTeams = false
    @State private var nextPlayers = [Player]()
    
    var body: some View {
        VStack {
            if showPlayersList {
                TextField("Digite o nome do jogador", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    self.addPlayer()
                }) {
                    Text("Adicionar jogador")
                }
                .padding()
                if players.count > 0 {
                    Text("Jogadores:")
                        .font(.headline)
                    
                    List {
                        ForEach(players) { player in
                            HStack {
                                Text(player.name)
                                Spacer()
                                Button(action: {
                                    self.removePlayer(player)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
//                List(players) { player in
//                    Text(player.name)
//                }
            } else {
                VStack {
                    Text("Time 1:")
                        .font(.headline)
                        .padding()
                    
                    List(teams[0].players) { player in
                        Text(player.name)
                    }
                    
                    Spacer()
                    
                    Text("Time 2:")
                        .font(.headline)
                        .padding()
                    
                    List(teams[1].players) { player in
                        Text(player.name)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            HStack {
                if hasTeams {
                    Button(action: {
                        self.resetState()
                    }) {
                        Text("Novo sorteio")
                    }
                    .padding()
                } else {
                    Button(action: {
                        self.randomizeTeams()
                        self.showPlayersList = false
                    }) {
                        Text("Sortear times")
                    }
                    .padding()
                    .disabled(players.count < 14 || players.count % 2 != 0 || teams.count > 0 || players.isEmpty)
                }
                
                Spacer()
            }
            
            Spacer()
        }
    }
    
    func removePlayer(_ player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players.remove(at: index)
        }
    }
    
    func addPlayer() {
        players.append(Player(name: playerName))
        playerName = ""
    }
    
    func randomizeTeams() {
        let shuffledPlayers = players.shuffled()
        let halfCount = shuffledPlayers.count / 2
        let firstTeamPlayers = Array(shuffledPlayers.prefix(halfCount))
        let secondTeamPlayers = Array(shuffledPlayers.suffix(halfCount))
        
        let team1 = Team(name: "Time 1", players: firstTeamPlayers)
        let team2 = Team(name: "Time 2", players: secondTeamPlayers)
        
        teams = [team1, team2]
        hasTeams = true
    }
    
    func resetState() {
        playerName = ""
        players = []
        teams = []
        showPlayersList = true
        hasTeams = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
