//
//  HealthKitHelper.swift
//  StepCounter
//
//  Created by ElamParithi Arul on 2020-06-23.
//  Copyright © 2020 Parithi Network. All rights reserved.
//

import HealthKit

// Helper class to use Apple HealthKit
class HealthKitHelper {
    
    // Type of Errors
    private enum HealthKitError: Error {
        case unauthorized
        case unsupportedDevice
        case dataUnavailable
    }
    
    // Method to ask permission to access Step Count data from HealthKit
    class func authorize(completion: @escaping (Bool, Error?) -> Void) {
        
        // Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitError.unsupportedDevice)
            return
        }
        
        // Check if step data is available on the device
        guard let stepData = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(false, HealthKitError.dataUnavailable)
            return
        }
        
        let requiredDataTypes : Set<HKObjectType> = [stepData]
        
        let healthStore = HKHealthStore()
        
        // Obtain Permission if read permission is not obtained
        if healthStore.authorizationStatus(for: stepData) != .sharingAuthorized {
            healthStore.requestAuthorization(toShare: [stepData], read: requiredDataTypes) { (success, error) in
                if (healthStore.authorizationStatus(for: stepData) != .sharingAuthorized) {
                    completion(false, HealthKitError.unauthorized)
                } else {
                    completion(success, error)
                }
            }
        } else {
            completion(true, nil)
        }
    }
    
    class func fetchStepDetails(completion: @escaping (StepData?) -> Void) {
        // Initializing the step count type
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // Preparing the date set to retreive data for past 7 days
        let daysToFetch = 7
        let currentDate = Date()
        let pastDateAtCurrentTime = Calendar.current.date(byAdding: DateComponents(day: -daysToFetch), to: currentDate)!
        let startDate = Calendar.current.startOfDay(for: pastDateAtCurrentTime)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: currentDate, options: .strictStartDate)
        
        // Create a query to fetch the step data from HealthKit
        let query = HKStatisticsCollectionQuery.init(quantityType: stepCountType,
                                                     quantitySamplePredicate: predicate,
                                                     options: .cumulativeSum,
                                                     anchorDate: startDate,
                                                     intervalComponents: DateComponents(day: 1))
        
        query.initialResultsHandler = { query, results, error in
            
            guard let results = results else {
                completion(nil)
                return
            }
            
            results.enumerateStatistics(from: startDate, to: currentDate) { stats, _ in
                if let sumQuantity = stats.sumQuantity() {
                    let stepValue = sumQuantity.doubleValue(for: HKUnit.count())
                    completion(StepData(date: stats.startDate, stepCount: stepValue))
                }
            }
        }
        
        // Execute the Query
        HKHealthStore().execute(query)
    }
}
