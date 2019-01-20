class WorkflowEntry {
    let name: String
    var currentItemName: String

    init(name: String, currentItemName: String) {
        self.name = name
        self.currentItemName = currentItemName
    }

    convenience init(name: String) {
        self.init(name: name, currentItemName: "N/A")
    }
}
