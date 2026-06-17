import Foundation

public struct District: Identifiable, Equatable, Sendable, Codable {
    public let id: String
    public let englishName: String
    public let banglaName: String
    public let division: String
    public let coordinate: GeoCoordinate

    public init(id: String, englishName: String, banglaName: String, division: String, coordinate: GeoCoordinate) {
        self.id = id
        self.englishName = englishName
        self.banglaName = banglaName
        self.division = division
        self.coordinate = coordinate
    }
}

public enum BangladeshDistricts {
    public static let dhaka = District(
        id: "dhaka",
        englishName: "Dhaka",
        banglaName: "ঢাকা",
        division: "Dhaka",
        coordinate: GeoCoordinate(latitude: 23.8103, longitude: 90.4125)
    )

    public static let all: [District] = [
        District(id: "bagerhat", englishName: "Bagerhat", banglaName: "বাগেরহাট", division: "Khulna", coordinate: GeoCoordinate(latitude: 22.6516, longitude: 89.7859)),
        District(id: "bandarban", englishName: "Bandarban", banglaName: "বান্দরবান", division: "Chattogram", coordinate: GeoCoordinate(latitude: 22.1953, longitude: 92.2184)),
        District(id: "barguna", englishName: "Barguna", banglaName: "বরগুনা", division: "Barishal", coordinate: GeoCoordinate(latitude: 22.0953, longitude: 90.1121)),
        District(id: "barishal", englishName: "Barishal", banglaName: "বরিশাল", division: "Barishal", coordinate: GeoCoordinate(latitude: 22.7010, longitude: 90.3535)),
        District(id: "bhola", englishName: "Bhola", banglaName: "ভোলা", division: "Barishal", coordinate: GeoCoordinate(latitude: 22.6859, longitude: 90.6482)),
        District(id: "bogura", englishName: "Bogura", banglaName: "বগুড়া", division: "Rajshahi", coordinate: GeoCoordinate(latitude: 24.8465, longitude: 89.3773)),
        District(id: "brahmanbaria", englishName: "Brahmanbaria", banglaName: "ব্রাহ্মণবাড়িয়া", division: "Chattogram", coordinate: GeoCoordinate(latitude: 23.9571, longitude: 91.1119)),
        District(id: "chandpur", englishName: "Chandpur", banglaName: "চাঁদপুর", division: "Chattogram", coordinate: GeoCoordinate(latitude: 23.2333, longitude: 90.6712)),
        District(id: "chattogram", englishName: "Chattogram", banglaName: "চট্টগ্রাম", division: "Chattogram", coordinate: GeoCoordinate(latitude: 22.3569, longitude: 91.7832)),
        District(id: "chuadanga", englishName: "Chuadanga", banglaName: "চুয়াডাঙ্গা", division: "Khulna", coordinate: GeoCoordinate(latitude: 23.6402, longitude: 88.8418)),
        District(id: "cox-bazar", englishName: "Cox's Bazar", banglaName: "কক্সবাজার", division: "Chattogram", coordinate: GeoCoordinate(latitude: 21.4272, longitude: 92.0058)),
        District(id: "cumilla", englishName: "Cumilla", banglaName: "কুমিল্লা", division: "Chattogram", coordinate: GeoCoordinate(latitude: 23.4607, longitude: 91.1809)),
        District(id: "dhaka", englishName: "Dhaka", banglaName: "ঢাকা", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.8103, longitude: 90.4125)),
        District(id: "dinajpur", englishName: "Dinajpur", banglaName: "দিনাজপুর", division: "Rangpur", coordinate: GeoCoordinate(latitude: 25.6217, longitude: 88.6354)),
        District(id: "faridpur", englishName: "Faridpur", banglaName: "ফরিদপুর", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.6070, longitude: 89.8429)),
        District(id: "feni", englishName: "Feni", banglaName: "ফেনী", division: "Chattogram", coordinate: GeoCoordinate(latitude: 23.0159, longitude: 91.3976)),
        District(id: "gaibandha", englishName: "Gaibandha", banglaName: "গাইবান্ধা", division: "Rangpur", coordinate: GeoCoordinate(latitude: 25.3287, longitude: 89.5285)),
        District(id: "gazipur", englishName: "Gazipur", banglaName: "গাজীপুর", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.9999, longitude: 90.4203)),
        District(id: "gopalganj", englishName: "Gopalganj", banglaName: "গোপালগঞ্জ", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.0050, longitude: 89.8266)),
        District(id: "habiganj", englishName: "Habiganj", banglaName: "হবিগঞ্জ", division: "Sylhet", coordinate: GeoCoordinate(latitude: 24.3745, longitude: 91.4155)),
        District(id: "jamalpur", englishName: "Jamalpur", banglaName: "জামালপুর", division: "Mymensingh", coordinate: GeoCoordinate(latitude: 24.9375, longitude: 89.9371)),
        District(id: "jashore", englishName: "Jashore", banglaName: "যশোর", division: "Khulna", coordinate: GeoCoordinate(latitude: 23.1697, longitude: 89.2137)),
        District(id: "jhalokati", englishName: "Jhalokati", banglaName: "ঝালকাঠি", division: "Barishal", coordinate: GeoCoordinate(latitude: 22.6406, longitude: 90.1987)),
        District(id: "jhenaidah", englishName: "Jhenaidah", banglaName: "ঝিনাইদহ", division: "Khulna", coordinate: GeoCoordinate(latitude: 23.5448, longitude: 89.1539)),
        District(id: "joypurhat", englishName: "Joypurhat", banglaName: "জয়পুরহাট", division: "Rajshahi", coordinate: GeoCoordinate(latitude: 25.0968, longitude: 89.0227)),
        District(id: "khagrachhari", englishName: "Khagrachhari", banglaName: "খাগড়াছড়ি", division: "Chattogram", coordinate: GeoCoordinate(latitude: 23.1193, longitude: 91.9847)),
        District(id: "khulna", englishName: "Khulna", banglaName: "খুলনা", division: "Khulna", coordinate: GeoCoordinate(latitude: 22.8456, longitude: 89.5403)),
        District(id: "kishoreganj", englishName: "Kishoreganj", banglaName: "কিশোরগঞ্জ", division: "Dhaka", coordinate: GeoCoordinate(latitude: 24.4449, longitude: 90.7766)),
        District(id: "kurigram", englishName: "Kurigram", banglaName: "কুড়িগ্রাম", division: "Rangpur", coordinate: GeoCoordinate(latitude: 25.8054, longitude: 89.6362)),
        District(id: "kushtia", englishName: "Kushtia", banglaName: "কুষ্টিয়া", division: "Khulna", coordinate: GeoCoordinate(latitude: 23.9013, longitude: 89.1206)),
        District(id: "lakshmipur", englishName: "Lakshmipur", banglaName: "লক্ষ্মীপুর", division: "Chattogram", coordinate: GeoCoordinate(latitude: 22.9447, longitude: 90.8282)),
        District(id: "lalmonirhat", englishName: "Lalmonirhat", banglaName: "লালমনিরহাট", division: "Rangpur", coordinate: GeoCoordinate(latitude: 25.9923, longitude: 89.2847)),
        District(id: "madaripur", englishName: "Madaripur", banglaName: "মাদারীপুর", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.1641, longitude: 90.1897)),
        District(id: "magura", englishName: "Magura", banglaName: "মাগুরা", division: "Khulna", coordinate: GeoCoordinate(latitude: 23.4855, longitude: 89.4198)),
        District(id: "manikganj", englishName: "Manikganj", banglaName: "মানিকগঞ্জ", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.8644, longitude: 90.0047)),
        District(id: "meherpur", englishName: "Meherpur", banglaName: "মেহেরপুর", division: "Khulna", coordinate: GeoCoordinate(latitude: 23.7622, longitude: 88.6318)),
        District(id: "moulvibazar", englishName: "Moulvibazar", banglaName: "মৌলভীবাজার", division: "Sylhet", coordinate: GeoCoordinate(latitude: 24.4829, longitude: 91.7774)),
        District(id: "munshiganj", englishName: "Munshiganj", banglaName: "মুন্সিগঞ্জ", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.5422, longitude: 90.5305)),
        District(id: "mymensingh", englishName: "Mymensingh", banglaName: "ময়মনসিংহ", division: "Mymensingh", coordinate: GeoCoordinate(latitude: 24.7471, longitude: 90.4203)),
        District(id: "naogaon", englishName: "Naogaon", banglaName: "নওগাঁ", division: "Rajshahi", coordinate: GeoCoordinate(latitude: 24.7936, longitude: 88.9318)),
        District(id: "narail", englishName: "Narail", banglaName: "নড়াইল", division: "Khulna", coordinate: GeoCoordinate(latitude: 23.1725, longitude: 89.5125)),
        District(id: "narayanganj", englishName: "Narayanganj", banglaName: "নারায়ণগঞ্জ", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.6238, longitude: 90.4990)),
        District(id: "narsingdi", englishName: "Narsingdi", banglaName: "নরসিংদী", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.9322, longitude: 90.7151)),
        District(id: "natore", englishName: "Natore", banglaName: "নাটোর", division: "Rajshahi", coordinate: GeoCoordinate(latitude: 24.4206, longitude: 89.0003)),
        District(id: "nawabganj", englishName: "Chapai Nawabganj", banglaName: "চাঁপাইনবাবগঞ্জ", division: "Rajshahi", coordinate: GeoCoordinate(latitude: 24.5965, longitude: 88.2775)),
        District(id: "netrokona", englishName: "Netrokona", banglaName: "নেত্রকোণা", division: "Mymensingh", coordinate: GeoCoordinate(latitude: 24.8709, longitude: 90.7279)),
        District(id: "nilphamari", englishName: "Nilphamari", banglaName: "নীলফামারী", division: "Rangpur", coordinate: GeoCoordinate(latitude: 25.9311, longitude: 88.8560)),
        District(id: "noakhali", englishName: "Noakhali", banglaName: "নোয়াখালী", division: "Chattogram", coordinate: GeoCoordinate(latitude: 22.8696, longitude: 91.0995)),
        District(id: "pabna", englishName: "Pabna", banglaName: "পাবনা", division: "Rajshahi", coordinate: GeoCoordinate(latitude: 24.0064, longitude: 89.2372)),
        District(id: "panchagarh", englishName: "Panchagarh", banglaName: "পঞ্চগড়", division: "Rangpur", coordinate: GeoCoordinate(latitude: 26.3411, longitude: 88.5542)),
        District(id: "patuakhali", englishName: "Patuakhali", banglaName: "পটুয়াখালী", division: "Barishal", coordinate: GeoCoordinate(latitude: 22.3596, longitude: 90.3296)),
        District(id: "pirojpur", englishName: "Pirojpur", banglaName: "পিরোজপুর", division: "Barishal", coordinate: GeoCoordinate(latitude: 22.5841, longitude: 89.9720)),
        District(id: "rajbari", englishName: "Rajbari", banglaName: "রাজবাড়ী", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.7574, longitude: 89.6445)),
        District(id: "rajshahi", englishName: "Rajshahi", banglaName: "রাজশাহী", division: "Rajshahi", coordinate: GeoCoordinate(latitude: 24.3745, longitude: 88.6042)),
        District(id: "rangamati", englishName: "Rangamati", banglaName: "রাঙ্গামাটি", division: "Chattogram", coordinate: GeoCoordinate(latitude: 22.6533, longitude: 92.1751)),
        District(id: "rangpur", englishName: "Rangpur", banglaName: "রংপুর", division: "Rangpur", coordinate: GeoCoordinate(latitude: 25.7439, longitude: 89.2752)),
        District(id: "satkhira", englishName: "Satkhira", banglaName: "সাতক্ষীরা", division: "Khulna", coordinate: GeoCoordinate(latitude: 22.7185, longitude: 89.0705)),
        District(id: "shariatpur", englishName: "Shariatpur", banglaName: "শরীয়তপুর", division: "Dhaka", coordinate: GeoCoordinate(latitude: 23.2423, longitude: 90.4348)),
        District(id: "sherpur", englishName: "Sherpur", banglaName: "শেরপুর", division: "Mymensingh", coordinate: GeoCoordinate(latitude: 25.0205, longitude: 90.0153)),
        District(id: "sirajganj", englishName: "Sirajganj", banglaName: "সিরাজগঞ্জ", division: "Rajshahi", coordinate: GeoCoordinate(latitude: 24.4534, longitude: 89.7007)),
        District(id: "sunamganj", englishName: "Sunamganj", banglaName: "সুনামগঞ্জ", division: "Sylhet", coordinate: GeoCoordinate(latitude: 25.0658, longitude: 91.3950)),
        District(id: "sylhet", englishName: "Sylhet", banglaName: "সিলেট", division: "Sylhet", coordinate: GeoCoordinate(latitude: 24.8949, longitude: 91.8687)),
        District(id: "tangail", englishName: "Tangail", banglaName: "টাঙ্গাইল", division: "Dhaka", coordinate: GeoCoordinate(latitude: 24.2513, longitude: 89.9167)),
        District(id: "thakurgaon", englishName: "Thakurgaon", banglaName: "ঠাকুরগাঁও", division: "Rangpur", coordinate: GeoCoordinate(latitude: 26.0337, longitude: 88.4616))
    ]

    public static func find(id: String) -> District? {
        all.first { $0.id == id }
    }
}
