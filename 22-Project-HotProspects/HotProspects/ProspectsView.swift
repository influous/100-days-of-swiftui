//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Toto on 20/05/2025.
//

import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType: String, CaseIterable, Identifiable {
        case name = "Name"
        case recent = "Most Recent"
        var id: String { self.rawValue }
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    @Environment(\.modelContext) private var modelContext
    @Query var allProspects: [Prospect]
    
    var prospects: [Prospect] {
        switch sortType {
        case .name:
            return allProspects.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .recent:
            return Array(allProspects.reversed())
        }
    }
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    @State private var sortType: SortType = .name
    
    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                NavigationLink(destination: EditView(prospect: prospect)) {
                    HStack {
                        Image(systemName: prospect.isContacted ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.xmark")
                            .foregroundStyle(prospect.isContacted ? .blue : .gray)
                            .padding(.trailing, 4)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.email)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
            }
            .navigationTitle(title)
            .onAppear {
                selectedProspects.removeAll()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortType) {
                            ForEach(SortType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Tobias\tobias@kook.work", completion: handleScan)
            }
        }
    }
    
    init(filter: FilterType) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            
            _allProspects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: [SortDescriptor(\Prospect.name)])
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else {
                return
            }
            
            let person = Prospect(name: details[0], email: details[1], isContacted: false)
            modelContext.insert(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription    )
                    }
                }
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
