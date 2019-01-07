import Foundation


class Entertainment {
    // static array variable that will contain a pool of all possible entertainments
    static let generalOptions = Entertainment.generateGeneralOptions()
    
    // properties
    var name: String
    var cost: Double
    var location: String
    
    static func generateGeneralOptions() -> [Entertainment] {
        var options = [Entertainment]()
        
        // activities
        let activity = Activity(name: "Horseback riding", cost: 60)
        activity.difficulty = .intermediate
        activity.weatherConditions = "No heavy rain"
        options.append(activity)
        
        // arts
        let arts = Arts(name: "MoMA", cost: 12)
        arts.genre = .modern
        arts.teaser = "Items: is fashion modern? "
        arts.ageLimit = 0
        options.append(arts)
        
        // gastronomy
        let gastronomy = Gastronomy(name: "Rissotto and Pizza", cost: 60)
        gastronomy.cuisine = "Italian"
        gastronomy.dressCode = .casual
        gastronomy.minNumberOfPeople = 4
        options.append(gastronomy)
        
        return options
    }
    
    // initializer
    init(name: String, cost: Double) {
        self.name = name
        self.cost = cost
        location = ""
    }
    
    func tellStory() -> String {
        return "It was fun to experience \(name) "
    }
    
}

// Enums
enum Difficulty: String {
    case hard = "Hard"
    case intermediate = "Intermediate"
    case easy = "Easy"
}

enum Genre: String {
    case classical = "Classical"
    case modern = "Modern"
    case historical = "Historical"
}

enum DressCode: String {
    case streetwear = "Streetwear"
    case casual = "Casual"
    case formal = "Formal"
}

// Sub Classes
class Activity: Entertainment {
    var weatherConditions = ""
    var equipmentRequired = ""
    var difficulty: Difficulty = .intermediate
    
    override func tellStory() -> String {
        // intro - print using the parent implementation
        super.tellStory()
        
        var story = " "
        
        // mention about weather requirements
        story += "Oh, the weather requirement: \(weatherConditions) - "
        
        // finish off with the financial impacts
        if cost <= 30 {
            story += "All that for only \(cost). "
        }
        else if cost >= 100 {
            story += "It was expensive - \(cost) - but definitely worth it."
        }
        else {
            story += "It was affordable at a price of $\(cost). "
        }
        
        // share the full story
        return story
    }
}


class Arts: Entertainment {
    var genre: Genre = .modern
    var ageLimit = 0
    var teaser = ""
    
    override func tellStory() -> String {
        // intro
        var story = "\(name) was an interesting experience - "
        
        // talk about genre
        story += "It was \(genre.rawValue) - "
        switch genre {
        case .modern:
            story += "my cup of tea - "
        default:
            story += "I'm not a big fan, but it was educational! "
        }
        
        // share teasure
        story += teaser
        
        // mention age restrictions
        if ageLimit > 0 {
            story += "You must be at least \(ageLimit) years of age to participate. "
        }
        else {
            story += "It's suitable for everyone. "
        }
        
        // financial impact
        story += "It cost me $\(cost). "
        
        // share the full story
        return story
    }
}


class Gastronomy: Entertainment {
    var dressCode: DressCode = .casual
    var cuisine = ""
    var minNumberOfPeople = 1
    
    override func tellStory() -> String {
        
        // intro
        var story = "\(name) was amazing! "
        
        // about cuisine
        story += "\(cuisine) was delicious. "
        
        // mention booking requirements
        if minNumberOfPeople > 1 {
            story += "I could go by myself - loved the food! "
        }
        
        // share the dress code info
        story += "There was a \(dressCode.rawValue) - "
        switch dressCode {
        case .streetwear:
            story += "no need to change before going "
        case .casual:
            story += "nothing fancy, very simple! "
        case .formal:
            story += "A great opportunity to dress up! "
        }
        
        // financial impact
        story += "All that for \(cost) "
        
        // share the full story
        return story
    }
}
for entertainment in Entertainment.generalOptions {
    print(entertainment.tellStory())
}


class Destination {
    // properties
    var name: String
    var cost: Double
    var entertainmentOptions = [Entertainment]()
    var accomplishments = [Entertainment]()
    
    // initializer
    init(name: String, cost: Double, entertainmentOptions: [Entertainment]) {
        self.name = name
        self.cost = cost
        self.entertainmentOptions = entertainmentOptions
        accomplishments = []
    }
    convenience init(name: String, cost: Double) {
        var options = [Entertainment]()
        var pool = Entertainment.generalOptions
        let numberOfOptions = Int(arc4random_uniform(UInt32(pool.count))) + 1
        
        if pool.count > 0 {
            for _ in 0 ..< numberOfOptions {
                let randomIndex = Int(arc4random_uniform(UInt32(pool.count)))
                options.append(pool[randomIndex])
                pool.remove(at: randomIndex)
            }
        }
        self.init(name: name, cost: cost, entertainmentOptions: options)
    }
    
    // methods
    func pickEntertainment(availableBudget: Double) -> Entertainment? {
        var pool = entertainmentOptions
        
        if pool.count == 0 {
            return nil
        }
        
        while true { // going through all the elements randomly to see if anything fits
            let randomIndex = Int(arc4random_uniform(UInt32(pool.count)))
            let nextEntertainment = pool[randomIndex]
            
            if nextEntertainment.cost <= availableBudget && !accomplishments.contains(where: {$0.name == nextEntertainment.name}) {
                return nextEntertainment // return once found a suitable element
            }
            
            pool.remove(at: randomIndex)
            if pool.count == 0 {
                return nil // returning once nothing left to check
            }
        }
        
    }
    
    func haveFun(availableBudget: Double) -> Double {
        accomplishments.removeAll()
        var amountSpent = 0.0
        var budget = availableBudget
        
        while let nextAccomplishment = pickEntertainment(availableBudget: budget) {
            accomplishments.append(nextAccomplishment)
            amountSpent += nextAccomplishment.cost
            budget -= nextAccomplishment.cost
        }
        return amountSpent
    }
    
    // tell story
    func tellStory() -> String {
        
        // create a variable to collect the sum of accomplishments cost
        var accomplishmentsCost = 0.0
        
        // intro
        var story = "It was great to visit \(name) \n "
        
        // summary
        if accomplishments.count > 0 {
            story += "while there I was lucky to have an opportunity to do \(accomplishments.count) things: \n "
        }
        else {
            story += "Sadly I wasn't able to do anything there: \n "
        }
        
        for entertainment in accomplishments {
            
            // add individual story
            story += entertainment.tellStory()
            
            // highlight subclass specific info
            if let activity = entertainment as? Activity {
                story += "I liked that it was \(activity.difficulty) \n"
            }
            else if let arts = entertainment as? Arts {
                story += "I liked that it was of \(arts.genre) genre \n"
            }
            else if let gastronomy = entertainment as? Gastronomy {
                story += "I liked that it was of \(gastronomy.cuisine) cuisine \n"
            }
            
            // include the cost in total
            accomplishmentsCost += entertainment.cost
        }
        
        // financial impact
        story += "The visit without entertainment cost me $\(cost). \n"
        story += "The total cost including entertainment amounted to $\(accomplishmentsCost + cost). \n"
        
        return story
    }
    
}

var destination = Destination(name: "New York City", cost: 800.0, entertainmentOptions: Entertainment.generalOptions)// cheating
destination.accomplishments = Entertainment.generalOptions // cheating

print(destination.tellStory())



class Adventure {
    // static properties
    static let maxDestinations = 5
    static let totalBudget = 10000.0
    static let returnCost = 800.0
    
    // properties
    var amountSpent: Double
    var destinations = [Destination]()
    var placesVisited = [Destination]()
    
    var amountRemaining: Double {
        return Adventure.totalBudget - Adventure.returnCost - amountSpent
    }
    
    // initializer
    init(destinations: [Destination]) {
        self.destinations = destinations
        amountSpent = 0.0
        placesVisited = []
    }
    
    convenience init() {
        let options = [
            Destination(name: "New York City", cost: 800.0),
            Destination(name: "Warsaw", cost: 1200.0),
            Destination(name: "Paris", cost: 1200.0),
            Destination(name: "Tokyo", cost: 2000.0),
            Destination(name: "Rome", cost: 1050.0),
            Destination(name: "Lisbon", cost: 700.0),
        ]
        self.init(destinations: options)
    }
    
    // methods
    func pickDestination() -> Destination? {
        var pool = destinations
        
        if pool.count == 0 || placesVisited.count >= Adventure.maxDestinations {
            return nil
        }
        
        while true { // going through all the elements randomly to see if anything fits
            
            let randomIndex = Int(arc4random_uniform(UInt32(pool.count)))
            let nextDestination = pool[randomIndex]
            
            if nextDestination.cost <= amountRemaining && !placesVisited.contains(where: {$0.name == nextDestination.name}) {
                return nextDestination // return once found a suitable element
            }
            
            pool.remove(at: randomIndex)
            if pool.count == 0 {
                return nil // returning once nothing left to check
            }
            
        }
    
    }
    
    func letsGo() {
        placesVisited.removeAll()
        amountSpent = 0.0
        while let nextDestination = pickDestination() {
            placesVisited.append(nextDestination)
            amountSpent += nextDestination.cost
            amountSpent += nextDestination.haveFun(availableBudget: amountRemaining)
        }
    }
    
    func tellStory() -> String {
        return ""
    }
}
