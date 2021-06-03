import XCTest
@testable import ios_stage_task

class StationTests: XCTestCase {

    var station: Station!

    override func setUpWithError() throws {
        station = CallStation()
    }

    override func tearDownWithError() throws {
    }

    func test_addUsers() throws {
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())

        XCTAssert(station.calls().isEmpty)
        XCTAssert(station.users().isEmpty)

        station.add(user: user1)
        station.add(user: user2)
        station.add(user: user1)

        XCTAssertEqual(station.users().count, 2)
    }

    func test_simpleCall_1() throws {
        // Добавляем пользователей
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())

        station.add(user: user1)
        station.add(user: user2)

        // User1 звонит User2
        let callID_1 = station.execute(action: .start(from: user1, to: user2))
        XCTAssertEqual(station.calls().count, 1)
        XCTAssertEqual(station.calls().first?.id, callID_1)
        XCTAssert(station.calls().first?.status == .calling)
        XCTAssertEqual(station.calls().first?.id, station.currentCall(user: user1)?.id)
        XCTAssertEqual(station.calls().first?.id, station.currentCall(user: user2)?.id)

        // User2 поднимает трубку
        let callID_2 = station.execute(action: .answer(from: user2))
        XCTAssertEqual(callID_1, callID_2)
        XCTAssert(station.calls().first?.status == .talk)

        // User1 завершает вызов
        let callID_3 = station.execute(action: .end(from: user1))
        XCTAssertEqual(callID_1, callID_3)
        XCTAssert(station.calls().first?.status == .ended(reason: .end))

        // Проверяем состояние станции
        XCTAssertNil(station.currentCall(user: user1))
        XCTAssertNil(station.currentCall(user: user2))
    }

    func test_simpleCall_2() throws {
        // Добавляем пользователей
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())

        station.add(user: user1)
        station.add(user: user2)

        // User1 звонит User2
        let callID_1 = station.execute(action: .start(from: user1, to: user2))
        XCTAssertEqual(station.calls().count, 1)
        XCTAssertEqual(station.calls().first?.id, callID_1)
        XCTAssert(station.calls().first?.status == .calling)
        XCTAssertEqual(station.calls().first?.id, station.currentCall(user: user1)?.id)
        XCTAssertEqual(station.calls().first?.id, station.currentCall(user: user2)?.id)

        // User2 отменяет вызов
        let callID_2 = station.execute(action: .end(from: user2))
        XCTAssertEqual(callID_1, callID_2)
        XCTAssert(station.calls().first?.status == .ended(reason: .cancel))

        // Проверяем состояние станции
        XCTAssertEqual(station.calls(user: user1).count, 1)
        XCTAssertEqual(station.calls(user: user2).count, 1)
        XCTAssertNil(station.currentCall(user: user1))
        XCTAssertNil(station.currentCall(user: user2))
    }

    func test_massiveCall_1() throws {
        // Добавляем пользователей
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())
        let user3 = User(id: UUID())
        let user4 = User(id: UUID())
        let user5 = User(id: UUID())
        let user6 = User(id: UUID())
        let user7 = User(id: UUID())
        let user8 = User(id: UUID())
        let user9 = User(id: UUID())
        let user10 = User(id: UUID())

        station.add(user: user1)
        station.add(user: user2)
        station.add(user: user3)
        station.add(user: user4)
        station.add(user: user5)
        station.add(user: user6)
        station.add(user: user7)
        station.add(user: user8)
        station.add(user: user9)
        station.add(user: user10)

        _ = station.execute(action: .start(from: user1, to: user2))
        _ = station.execute(action: .start(from: user3, to: user4))
        _ = station.execute(action: .start(from: user5, to: user6))
        _ = station.execute(action: .start(from: user7, to: user8))
        _ = station.execute(action: .start(from: user9, to: user10))

        station.calls().forEach {
            XCTAssert($0.status == .calling)
        }

        _ = station.execute(action: .answer(from: user2))
        _ = station.execute(action: .answer(from: user4))
        _ = station.execute(action: .answer(from: user6))
        _ = station.execute(action: .answer(from: user8))
        _ = station.execute(action: .answer(from: user10))

        station.calls().forEach {
            XCTAssert($0.status == .talk)
        }

        _ = station.execute(action: .end(from: user2))
        _ = station.execute(action: .end(from: user4))
        _ = station.execute(action: .end(from: user6))
        _ = station.execute(action: .end(from: user8))
        _ = station.execute(action: .end(from: user10))

        station.calls().forEach {
            XCTAssert($0.status == .ended(reason: .end))
        }
    }

    func test_simpleCall_busy_1() throws {
        // Добавляем пользователей
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())
        let user3 = User(id: UUID())

        station.add(user: user1)
        station.add(user: user2)
        station.add(user: user3)

        // User1 звонит User2
        let callID_1 = try XCTUnwrap(station.execute(action: .start(from: user1, to: user2)))
        XCTAssertEqual(station.calls().count, 1)
        XCTAssertEqual(station.calls().first?.id, callID_1)
        XCTAssert(station.calls().first?.status == .calling)
        XCTAssertEqual(station.calls().first?.id, station.currentCall(user: user1)?.id)
        XCTAssertEqual(station.calls().first?.id, station.currentCall(user: user2)?.id)

        // User2 поднимает трубку
        _ = station.execute(action: .answer(from: user2))
        XCTAssert(station.calls().first?.status == .talk)

        // User3 звонит User2
        let callID_2 = station.execute(action: .start(from: user3, to: user2))
        XCTAssertNotNil(callID_2)
        if let callID_2 = callID_2 {
            XCTAssert(station.call(id: callID_2)?.status == .ended(reason: .userBusy))
        }

        // User1 завершает вызов
        _ = station.execute(action: .end(from: user1))
        XCTAssert(station.call(id: callID_1)?.status == .ended(reason: .end))

        // Проверяем состояние станции
        XCTAssertNil(station.currentCall(user: user1))
        XCTAssertNil(station.currentCall(user: user2))
        XCTAssertEqual(station.calls(user: user1).count, 1)
        XCTAssertEqual(station.calls(user: user2).count, 2)
        XCTAssertEqual(station.calls(user: user3).count, 1)
    }

    func test_call_error_1() throws {
        // Добавляем пользователей
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())

        // User1 звонит User2
        let callID_1 = station.execute(action: .start(from: user1, to: user2))
        XCTAssertNil(callID_1)
    }

    func test_simpleCall_error_1() throws {
        // Добавляем пользователей
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())

        station.add(user: user1)

        // User1 звонит User2
        let callID_1 = station.execute(action: .start(from: user1, to: user2))
        XCTAssertEqual(station.calls().count, 1)
        XCTAssertEqual(station.calls().first?.id, callID_1)
        XCTAssert(station.calls().first?.status == .ended(reason: .error))

        // Проверяем состояние станции
        XCTAssertNil(station.currentCall(user: user1))
        XCTAssertNil(station.currentCall(user: user2))
    }

    func test_simpleCall_error_2() throws {
        // Добавляем пользователей
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())

        station.add(user: user1)
        station.add(user: user2)

        // User1 звонит User2
        let callID_1 = try XCTUnwrap(station.execute(action: .start(from: user1, to: user2)))
        XCTAssertEqual(station.calls().count, 1)
        XCTAssertEqual(station.calls().first?.id, callID_1)
        XCTAssert(station.calls().first?.status == .calling)
        XCTAssertEqual(station.calls().first?.id, station.currentCall(user: user1)?.id)
        XCTAssertEqual(station.calls().first?.id, station.currentCall(user: user2)?.id)

        // У User2 происходит обрыв
        station.remove(user: user2)

        // User2 поднимает трубку, но ничего не происходи
        let callID_2 = station.execute(action: .answer(from: user2))
        XCTAssertNil(callID_2)

        // Проверяем состояние звонка
        let call = station.call(id: callID_1)
        XCTAssert(call?.status == .ended(reason: .error))

        // Проверяем состояние станции
        XCTAssertNil(station.currentCall(user: user1))
        XCTAssertNil(station.currentCall(user: user2))
    }

    func test_call_history_empty_history() {
        let user1 = User(id: UUID())
        XCTAssertTrue(station.calls(user: user1).isEmpty)
    }

    func test_call_history_some_history() throws {
        let user1 = User(id: UUID())
        let user2 = User(id: UUID())
        station.add(user: user1)
        station.add(user: user2)
        let callID_1 = try XCTUnwrap(station.execute(action: .start(from: user1, to: user2)))
        XCTAssert(station.calls(user: user1).first?.id == callID_1)
        XCTAssert(station.calls(user: user2).first?.id == callID_1)

        let user3 = User(id: UUID())
        station.add(user: user3)
        let _ = try XCTUnwrap(station.execute(action: .start(from: user3, to: user2)))
        XCTAssertFalse(station.calls(user: user3).isEmpty)
    }
}
