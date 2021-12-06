//
// Wire
// Copyright (C) 2021 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation
import WireDataModel
import WireSyncEngine

extension CallClosedReason: AnalyticsAttributeValue {
    public var analyticsValue: String {
        switch self {
        case .normal:
            return "normal"
        case .canceled:
            return "cancelled"
        case .anweredElsewhere:
            return "answered_elsewhere"
        case .rejectedElsewhere:
            return "rejected"
        case .timeout:
            return "timeout"
        case .lostMedia:
            return "lost_media"
        case .internalError:
            return "internal_error"
        case .inputOutputError:
            return "io_error"
        case .stillOngoing:
            return "still_ongoing"
        case .securityDegraded:
            return "security_degraded"
        case .outdatedClient:
            return "outdated_client"
        case .unknown:
            return "unknown"
        }
    }

}

extension AnalyticsEvent {

    static func initiatedCall(asVideoCall: Bool, in conversation: ZMConversation) -> AnalyticsEvent {
        var event = AnalyticsEvent(name: "calling.initiated_call")
        event.attributes = conversation.analyticsAttributes
        event.attributes[.startedAsVideoCall] = asVideoCall
        return event
    }

    static func joinedCall(asVideoCall: Bool, callDirection: CallDirection, in conversation: ZMConversation) -> AnalyticsEvent {
        var event = AnalyticsEvent(name: "calling.joined_call")
        event.attributes = conversation.analyticsAttributes
        event.attributes[.startedAsVideoCall] = asVideoCall
        event.attributes[.callDirection] = callDirection
        return event
    }

    static func establishedCall(asVideoCall: Bool, in conversation: ZMConversation) -> AnalyticsEvent {
        var event = AnalyticsEvent(name: "calling.established_call")
        event.attributes = conversation.analyticsAttributes
        event.attributes[.startedAsVideoCall] = asVideoCall
        return event
    }

    static func screenShare(callDirection: CallDirection, duration: Double, in conversation: ZMConversation) -> AnalyticsEvent {
        var event = AnalyticsEvent(name: "calling.screen_share")
        event.attributes = conversation.analyticsAttributes
        event.attributes[.callDirection] = callDirection
        event.attributes[.screenShareDuration] =  RoundedInt(Int(duration), factor: 6)
        return event
    }

    static func endedCall(asVideoCall: Bool,
                          callDirection: CallDirection,
                          callDuration: Double,
                          callParticipants: Int,
                          videoEnabled: Bool,
                          screenShareEnabled: Bool,
                          callClosedReason: CallClosedReason,
                          conversation: ZMConversation) -> AnalyticsEvent {
        var event = AnalyticsEvent(name: "calling.ended_call")
        event.attributes = conversation.analyticsAttributes
        event.attributes[.startedAsVideoCall] = asVideoCall
        event.attributes[.callDirection] = callDirection
        event.attributes[.callDuration] = RoundedInt(Int(callDuration), factor: 6)
        event.attributes[.callParticipants] = RoundedInt(Int(callParticipants), factor: 6)
        event.attributes[.videoEnabled] = videoEnabled
        event.attributes[.screenShareEnabled] = screenShareEnabled
        event.attributes[.callEndedReason] = callClosedReason
        return event
    }

    enum CallDirection: String, AnalyticsAttributeValue {

        case incoming
        case outgoing

        var analyticsValue: String {
            return rawValue
        }
    }

}

private extension AnalyticsAttributeKey {

    /// Whether a call started as a video call.
    ///
    /// Expected to refer to a value of type `Boolean`.
    static let startedAsVideoCall = AnalyticsAttributeKey(rawValue: "call_video")

    /// The direction of the call.
    ///
    /// Expected to refer to a value of type `AnalyticsCallDirectionType`.
    static let callDirection  = AnalyticsAttributeKey(rawValue: "call_direction")

    /// The duration of the call in seconds.
    ///
    /// Expected to refer to a value of type `RoundedInt`.
    static let callDuration  = AnalyticsAttributeKey(rawValue: "call_duration")

    /// The peak number of participants in the call.
    ///
    /// Expected to refer to a value of type `RoundedInt`.
    static let callParticipants  = AnalyticsAttributeKey(rawValue: "call_participants")

    /// Whether the video was enabled at least once by any user.
    ///
    /// Expected to refer to a value of type `Boolean`.
    static let videoEnabled  = AnalyticsAttributeKey(rawValue: "call_AV_switch_toggle")

    /// Whether screen sharing was enabled at least once by any user.
    ///
    /// Expected to refer to a value of type `Boolean`.
    static let screenShareEnabled  = AnalyticsAttributeKey(rawValue: "call_screen_share")

    /// The duration of the screen share in seconds.
    ///
    /// Expected to refer to a value of type `RoundedInt`.
    static let screenShareDuration = AnalyticsAttributeKey(rawValue: "screen_share_duration")

    /// The reason the call ended, according to AVS.
    ///
    /// Expected to refer to a value of type `CallClosedReason`.
    static let callEndedReason  = AnalyticsAttributeKey(rawValue: "call_end_reason")
}
