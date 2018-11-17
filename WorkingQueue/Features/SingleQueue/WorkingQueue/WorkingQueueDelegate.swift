protocol WorkingQueueDelegate {
    func didEnqueueAt(section: WorkingQueueSection, row: Int)
    func didDequeueAt(section: WorkingQueueSection, row: Int)
    func didRemoveAt(section: WorkingQueueSection, row: Int)
    func didMove(at: (section: WorkingQueueSection, row: Int), to: (section: WorkingQueueSection, row: Int))
    func didAddSection(_ section: WorkingQueueSection)
    func didRemoveSection(_ section: WorkingQueueSection)
}
