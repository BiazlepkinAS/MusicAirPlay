
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
                    [Song(name: "Gangsta paradise", artist: "Coolio", image: "Coolio", fileName: "Coolio", favorite: true),
                     Song(name: "kalinka", artist: "kalinka", image: "Kalinka", fileName: "kalinka", favorite: false),
                     Song(name: "Metallica", artist: "Matallica", image: "Metallica", fileName: "Metallica", favorite: true)
                    ]),
            Album(name: "Folk", image: "kalinka", songs:
                    [Song(name: "kalinka", artist: "kalinka", image: "Kalinka", fileName: "kalinka", favorite: false),
                     Song(name: "Gangsta paradise", artist: "Coolio", image: "Coolio", fileName: "Cooli0", favorite: true),
                     Song(name: "Metallica", artist: "Matallica", image: "Metallica", fileName: "Metallica", favorite: true)
                    ]),
            Album(name: "Rock", image: "Metalica", songs:
                    [Song(name: "Metallica", artist: "Matallica", image: "Metallica", fileName: "Metallica", favorite: true),
                     Song(name: "Gangsta paradise", artist: "Coolio", image: "Coolio", fileName: "Coolio", favorite: true),
                     Song(name: "kalinka", artist: "kalinka", image: "Kalinka", fileName: "kalinka", favorite: false),
                    ])
        ]
    }
}
