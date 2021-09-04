
import Foundation

struct Album {
    var name: String
    var image: String
    var songs: [Song]
}

extension Album {
    
    static func get() -> [Album] {
        return [
            Album(name: "Rap", image: "Coolio", songs:
                    [Song(name: "Gansta paradise", artist: "Coolio", image: "Coolio", fileName: "Cooli", favorite: true),
                     Song(name: "kalinka", artist: "kalinka", image: "Kalinka", fileName: "kalinka", favorite: false),
                     Song(name: "Metalica", artist: "Matalica", image: "Metalica", fileName: "Metalica", favorite: true)
                    ]),
            Album(name: "Folk", image: "kalinka", songs:
                    [Song(name: "kalinka", artist: "kalinka", image: "Kalinka", fileName: "kalinka", favorite: false),
                     Song(name: "Gansta paradise", artist: "Coolio", image: "Coolio", fileName: "Cooli", favorite: true),
                     Song(name: "Metalica", artist: "Matalica", image: "Metalica", fileName: "Metalica", favorite: true)
                    ]),
            Album(name: "Rock", image: "Metalica", songs:
                    [Song(name: "Metalica", artist: "Matalica", image: "Metalica", fileName: "Metalica", favorite: true),
                     Song(name: "Gansta paradise", artist: "Coolio", image: "Coolio", fileName: "Cooli", favorite: true),
                     Song(name: "kalinka", artist: "kalinka", image: "Kalinka", fileName: "kalinka", favorite: false),
                    ])
        ]
    }
}
