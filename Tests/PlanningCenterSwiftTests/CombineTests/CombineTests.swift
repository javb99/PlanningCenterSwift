//
//  Created by Joseph Van Boxtel on 11/12/19.
//

/// Operators the respect Demand d
/// d     .map()
/// n*d   .collect(n)
/// d     .append(Sequence)
/// d     .append(Publisher)
/// d     .scan()
/// d     .assertNoFailure()
/// d     .removeDuplicates()
/// d     .replaceError()
/// d     .replaceEmpty()
/// d     .filter()
/// k  *  .flatMap(maxPublishers: k, {})
/// 1     .dropFirst()
/// min(n,d) .dropFirst(n)
/// n  *  .prefix(k)
/// n     .prefix(while:)
/// n  *  .output(at: k)
/// n  *  .output(in: )
/// n     .drop(untilOutputFrom: Publisher) demands 1 from paramer pub
/// n     .prefix(untilOutputFrom: Publisher) demands 1 from paramer pub
/// n     .zip() both demand n
/// 1     .merge() both demand 1 at a time. result is interleaved
/// n     .combineLatest() both demand n
/// n     .catch({})
/// n     .print()
///
///
/// Operators that don't respect Demand
/// unlimited .first()
/// unlimited .first(where:{})
/// unlimited .last()
/// unlimited .last(where:{})
/// unlimited .collect() can logically only reply to a demand of 1
/// unlimited .reduce(:,:)
/// unlimited .ignoreOutput()
/// unlimited .flatMap({})
/// unlimited .count()  by definition
/// unlimited .allSatisfy()
/// unlimited .contains()
/// ....      .multicast()
/// unlimited .switchToLatests()
///
