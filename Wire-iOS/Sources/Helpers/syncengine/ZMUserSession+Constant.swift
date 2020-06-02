//
// Wire
// Copyright (C) 2019 Wire Swiss GmbH
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

import WireSyncEngine

extension ZMUserSession {
    static let MaxVideoWidth: UInt64 = 1920 // FullHD
    static let MaxFileSize: UInt64 = 26214400 // 25 megabytes (25 * 1024 * 1024)
    private static let MaxTeamFileSize: UInt64 = 104857600 // 100 megabytes (100 * 1024 * 1024)

    private static let MaxAudioLength: TimeInterval = 1500 // 25 minutes (25 * 60.0)
    private static let MaxTeamAudioLength: TimeInterval = 6000 // 100 minutes (100 * 60.0)

    private static let MaxVideoLength: TimeInterval = 240 // 4 minutes (4.0 * 60.0)
    private static let MaxTeamVideoLength: TimeInterval = 960 // 16 minutes (16.0 * 60.0)

    private var selfUserHasTeam: Bool {
        return ZMUser.selfUser(inUserSession: self).hasTeam
    }

    public var maxUploadFileSize: UInt64 {
        return ZMUserSession.uploadFileSizeLimit(hasTeam: selfUserHasTeam)
    }
    
    public static func uploadFileSizeLimit(hasTeam: Bool) -> UInt64 {
        return hasTeam ? ZMUserSession.MaxTeamFileSize : ZMUserSession.MaxFileSize
    }

    public var maxAudioLength: TimeInterval {
        return selfUserHasTeam ? ZMUserSession.MaxTeamAudioLength : ZMUserSession.MaxAudioLength
    }

    public var maxVideoLength: TimeInterval {
        return selfUserHasTeam ? ZMUserSession.MaxTeamVideoLength : ZMUserSession.MaxVideoLength
    }
}

