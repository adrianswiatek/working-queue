protocol QueueWithSectionsDelegate {
    func didEnqueueAt(section: Int, row: Int)
    func didDequeueAt(section: Int, row: Int)
    func didRemoveAt(section: Int, row: Int)
    func didMove(at: (section: Int, row: Int), to: (section: Int, row: Int))
    func didAddSection(_ section: Int)
    func didRemoveSection(_ section: Int)
}
