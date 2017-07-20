set_plugin_info{
	version     = "0.1.0",
	description = "Dissector for the Roblox network protocol",
	author      = "Anaminus",
	repository  = nil,
}

local roblox = Proto.new("roblox", "Roblox Network Protocol")

-- Appears to be constant.
roblox.prefs.server_port = Pref.uint("Server port", 53640, "The default server port.")
-- This should be a range.
roblox.prefs.client_port = Pref.uint("Client port", 64496, "The default client port.")

-- The protocol is based on Raknet, so these are Raknet packet IDs. Most
-- appear to be unused. The details of the most common packets (0x84, 0x8C)
-- still need to be worked out.
local ID = {
	CONNECTED_PING                                        = 0x00,
	UNCONNECTED_PING                                      = 0x01,
	UNCONNECTED_PING_OPEN_CONNECTIONS                     = 0x02,
	CONNECTED_PONG                                        = 0x03,
	DETECT_LOST_CONNECTIONS                               = 0x04,
	OPEN_CONNECTION_REQUEST_1                             = 0x05,
	OPEN_CONNECTION_REPLY_1                               = 0x06,
	OPEN_CONNECTION_REQUEST_2                             = 0x07,
	OPEN_CONNECTION_REPLY_2                               = 0x08,
	CONNECTION_REQUEST                                    = 0x09,
	REMOTE_SYSTEM_REQUIRES_PUBLIC_KEY                     = 0x0A,
	OUR_SYSTEM_REQUIRES_SECURITY                          = 0x0B,
	PUBLIC_KEY_MISMATCH                                   = 0x0C,
	OUT_OF_BAND_INTERNAL                                  = 0x0D,
	SND_RECEIPT_ACKED                                     = 0x0E,
	SND_RECEIPT_LOSS                                      = 0x0F,
	CONNECTION_REQUEST_ACCEPTED                           = 0x10,
	CONNECTION_ATTEMPT_FAILED                             = 0x11,
	ALREADY_CONNECTED                                     = 0x12,
	NEW_INCOMING_CONNECTION                               = 0x13,
	NO_FREE_INCOMING_CONNECTIONS                          = 0x14,
	DISCONNECTION_NOTIFICATION                            = 0x15,
	CONNECTION_LOST                                       = 0x16,
	CONNECTION_BANNED                                     = 0x17,
	INVALID_PASSWORD                                      = 0x18,
	INCOMPATIBLE_PROTOCOL_VERSION                         = 0x19,
	IP_RECENTLY_CONNECTED                                 = 0x1A,
	TIMESTAMP                                             = 0x1B,
	UNCONNECTED_PONG                                      = 0x1C,
	ADVERTISE_SYSTEM                                      = 0x1D,
	DOWNLOAD_PROGRESS                                     = 0x1E,
	REMOTE_DISCONNECTION_NOTIFICATION                     = 0x1F,
	REMOTE_CONNECTION_LOST                                = 0x20,
	REMOTE_NEW_INCOMING_CONNECTION                        = 0x21,
	FILE_LIST_TRANSFER_HEADER                             = 0x22,
	FILE_LIST_TRANSFER_FILE                               = 0x23,
	FILE_LIST_REFERENCE_PUSH_ACK                          = 0x24,
	DDT_DOWNLOAD_REQUEST                                  = 0x25,
	TRANSPORT_STRING                                      = 0x26,
	REPLICA_MANAGER_CONSTRUCTION                          = 0x27,
	REPLICA_MANAGER_SCOPE_CHANGE                          = 0x28,
	REPLICA_MANAGER_SERIALIZE                             = 0x29,
	REPLICA_MANAGER_DOWNLOAD_STARTED                      = 0x2A,
	REPLICA_MANAGER_DOWNLOAD_COMPLETE                     = 0x2B,
	RAKVOICE_OPEN_CHANNEL_REQUEST                         = 0x2C,
	RAKVOICE_OPEN_CHANNEL_REPLY                           = 0x2D,
	RAKVOICE_CLOSE_CHANNEL                                = 0x2E,
	RAKVOICE_DATA                                         = 0x2F,
	AUTOPATCHER_GET_CHANGELIST_SINCE_DATE                 = 0x30,
	AUTOPATCHER_CREATION_LIST                             = 0x31,
	AUTOPATCHER_DELETION_LIST                             = 0x32,
	AUTOPATCHER_GET_PATCH                                 = 0x33,
	AUTOPATCHER_PATCH_LIST                                = 0x34,
	AUTOPATCHER_REPOSITORY_FATAL_ERROR                    = 0x35,
	AUTOPATCHER_CANNOT_DOWNLOAD_ORIGINAL_UNMODIFIED_FILES = 0x36,
	AUTOPATCHER_FINISHED_INTERNAL                         = 0x37,
	AUTOPATCHER_FINISHED                                  = 0x38,
	AUTOPATCHER_RESTART_APPLICATION                       = 0x39,
	NAT_PUNCHTHROUGH_REQUEST                              = 0x3A,
	NAT_CONNECT_AT_TIME                                   = 0x3B,
	NAT_GET_MOST_RECENT_PORT                              = 0x3C,
	NAT_CLIENT_READY                                      = 0x3D,
	NAT_TARGET_NOT_CONNECTED                              = 0x3E,
	NAT_TARGET_UNRESPONSIVE                               = 0x3F,
	NAT_CONNECTION_TO_TARGET_LOST                         = 0x40,
	NAT_ALREADY_IN_PROGRESS                               = 0x41,
	NAT_PUNCHTHROUGH_FAILED                               = 0x42,
	NAT_PUNCHTHROUGH_SUCCEEDED                            = 0x43,
	READY_EVENT_SET                                       = 0x44,
	READY_EVENT_UNSET                                     = 0x45,
	READY_EVENT_ALL_SET                                   = 0x46,
	READY_EVENT_QUERY                                     = 0x47,
	LOBBY_GENERAL                                         = 0x48,
	RPC_REMOTE_ERROR                                      = 0x49,
	RPC_PLUGIN                                            = 0x4A,
	FILE_LIST_REFERENCE_PUSH                              = 0x4B,
	READY_EVENT_FORCE_ALL_SET                             = 0x4C,
	ROOMS_EXECUTE_FUNC                                    = 0x4D,
	ROOMS_LOGON_STATUS                                    = 0x4E,
	ROOMS_HANDLE_CHANGE                                   = 0x4F,
	LOBBY2_SEND_MESSAGE                                   = 0x50,
	LOBBY2_SERVER_ERROR                                   = 0x51,
	FCM2_NEW_HOST                                         = 0x52,
	FCM2_REQUEST_FCMGUID                                  = 0x53,
	FCM2_RESPOND_CONNECTION_COUNT                         = 0x54,
	FCM2_INFORM_FCMGUID                                   = 0x55,
	FCM2_UPDATE_MIN_TOTAL_CONNECTION_COUNT                = 0x56,
	FCM2_VERIFIED_JOIN_START                              = 0x57,
	FCM2_VERIFIED_JOIN_CAPABLE                            = 0x58,
	FCM2_VERIFIED_JOIN_FAILED                             = 0x59,
	FCM2_VERIFIED_JOIN_ACCEPTED                           = 0x5A,
	FCM2_VERIFIED_JOIN_REJECTED                           = 0x5B,
	UDP_PROXY_GENERAL                                     = 0x5C,
	SQLite3_EXEC                                          = 0x5D,
	SQLite3_UNKNOWN_DB                                    = 0x5E,
	SQLLITE_LOGGER                                        = 0x5F,
	NAT_TYPE_DETECTION_REQUEST                            = 0x60,
	NAT_TYPE_DETECTION_RESULT                             = 0x61,
	ROUTER_2_INTERNAL                                     = 0x62,
	ROUTER_2_FORWARDING_NO_PATH                           = 0x63,
	ROUTER_2_FORWARDING_ESTABLISHED                       = 0x64,
	ROUTER_2_REROUTED                                     = 0x65,
	TEAM_BALANCER_INTERNAL                                = 0x66,
	TEAM_BALANCER_REQUESTED_TEAM_FULL                     = 0x67,
	TEAM_BALANCER_REQUESTED_TEAM_LOCKED                   = 0x68,
	TEAM_BALANCER_TEAM_REQUESTED_CANCELLED                = 0x69,
	TEAM_BALANCER_TEAM_ASSIGNED                           = 0x6A,
	LIGHTSPEED_INTEGRATION                                = 0x6B,
	XBOX_LOBBY                                            = 0x6C,
	TWO_WAY_AUTHENTICATION_INCOMING_CHALLENGE_SUCCESS     = 0x6D,
	TWO_WAY_AUTHENTICATION_OUTGOING_CHALLENGE_SUCCESS     = 0x6E,
	TWO_WAY_AUTHENTICATION_INCOMING_CHALLENGE_FAILURE     = 0x6F,
	TWO_WAY_AUTHENTICATION_OUTGOING_CHALLENGE_FAILURE     = 0x70,
	TWO_WAY_AUTHENTICATION_OUTGOING_CHALLENGE_TIMEOUT     = 0x71,
	TWO_WAY_AUTHENTICATION_NEGOTIATION                    = 0x72,
	CLOUD_POST_REQUEST                                    = 0x73,
	CLOUD_RELEASE_REQUEST                                 = 0x74,
	CLOUD_GET_REQUEST                                     = 0x75,
	CLOUD_GET_RESPONSE                                    = 0x76,
	CLOUD_UNSUBSCRIBE_REQUEST                             = 0x77,
	CLOUD_SERVER_TO_SERVER_COMMAND                        = 0x78,
	CLOUD_SUBSCRIPTION_NOTIFICATION                       = 0x79,
	LIB_VOICE                                             = 0x7A,
	RELAY_PLUGIN                                          = 0x7B,
	NAT_REQUEST_BOUND_ADDRESSES                           = 0x7C,
	NAT_RESPOND_BOUND_ADDRESSES                           = 0x7D,
	FCM2_UPDATE_USER_CONTEXT                              = 0x7E,
	RESERVED_3                                            = 0x7F,
	RESERVED_4                                            = 0x80,
	RESERVED_5                                            = 0x81,
	RESERVED_6                                            = 0x82,
	RESERVED_7                                            = 0x83,
	RESERVED_8                                            = 0x84,
	RESERVED_9                                            = 0x85,
	USER_PACKET_ENUM                                      = 0x86,

	CUSTOM_0 = 0x80,
	CUSTOM_1 = 0x81,
	CUSTOM_2 = 0x82,
	CUSTOM_3 = 0x83,
	CUSTOM_4 = 0x84,
	CUSTOM_5 = 0x85,
	CUSTOM_6 = 0x86,
	CUSTOM_7 = 0x87,
	CUSTOM_8 = 0x88,
	CUSTOM_9 = 0x89,
	CUSTOM_A = 0x8A,
	CUSTOM_B = 0x8B,
	CUSTOM_C = 0x8C,
	CUSTOM_D = 0x8D,
	CUSTOM_E = 0x8E,
	CUSTOM_F = 0x8F,

	ACKNOWLEDGED     = 0xC0,
	NOT_ACKNOWLEDGED = 0xA0,
}

-- Set up all possible packet fields.
local field = {}

do
	-- Set the field to identify a value with its corresponding name.
	local idStrings = {}
	for name, value in pairs(ID) do
		idStrings[value] = "ID_" .. name
	end
	field.id = table.pack(ProtoField.uint8, "Roblox Packet ID", base.HEX, idStrings)
end
field.unknown          = table.pack(ProtoField.bytes,  "Unknown")
field.magic            = table.pack(ProtoField.bytes,  "Magic")
field.proto_ver        = table.pack(ProtoField.uint8,  "Protocol Version")
field.null_padding     = table.pack(ProtoField.bytes,   "Null Padding")
field.server_id        = table.pack(ProtoField.bytes,  "Server ID")
field.server_security  = table.pack(ProtoField.uint8,  "Server Security")
field.mtu_size         = table.pack(ProtoField.uint16, "MTU Size")
field.security         = table.pack(ProtoField.uint8,  "Security")
field.cookie           = table.pack(ProtoField.bytes,  "Cookie")
field.udp_port         = table.pack(ProtoField.uint16, "UDP Port")
field.client_id        = table.pack(ProtoField.bytes,  "Client ID")
field.record_number    = table.pack(ProtoField.uint24, "Record number")
field.ack_records      = table.pack(ProtoField.bytes,  "Records")
field.ack_record_count = table.pack(ProtoField.uint16, "Number of Records")
field.record           = table.pack(ProtoField.bytes,  "Record")
field.record_single    = table.pack(ProtoField.bool,   "Single")
field.record_min       = table.pack(ProtoField.uint24, "Minimum")
field.record_max       = table.pack(ProtoField.uint24, "Maximum")

-- Transform fields into ProtoFields.
do
	local sorted = {}
	for name in pairs(field) do
		sorted[#sorted+1] = name
	end
	table.sort(sorted)

	local fields = {}
	local list = {}
	for i = 1, #sorted do
		local name = sorted[i]
		local args = field[name]
		local f = args[1]("roblox." .. name, table.unpack(args, 2, args.n))
		list[i] = f
		fields[name] = f
	end
	roblox.fields = list
	field = fields
end

function roblox.dissector(buf, pkt, tree)
	local id = buf(0,1):uint()
	if id == ID.OPEN_CONNECTION_REQUEST_1 then
		local packet = tree:add(roblox, buf(0))
		packet:add(field.id,           buf(0,1))
		packet:add(field.magic,        buf(1,16))
		packet:add(field.proto_ver,    buf(17,1))
		packet:add(field.null_padding, buf(18))

	elseif id == ID.OPEN_CONNECTION_REPLY_1 then
		local packet = tree:add(roblox, buf(0))
		packet:add(field.id,              buf(0,1))
		packet:add(field.magic,           buf(1,16))
		packet:add(field.server_id,       buf(17,8))
		packet:add(field.server_security, buf(25,1))
		packet:add(field.mtu_size,        buf(26,2))

	elseif id == ID.OPEN_CONNECTION_REQUEST_2 then
		local packet = tree:add(roblox, buf(0))
		packet:add(field.id,        buf(0,1))
		packet:add(field.magic,     buf(1,16))
		packet:add(field.security,  buf(17,1))
		packet:add(field.cookie,    buf(18,4))
		packet:add(field.udp_port,  buf(22,2))
		packet:add(field.mtu_size,  buf(24,2))
		packet:add(field.client_id, buf(26,8))

	elseif id == ID.OPEN_CONNECTION_REPLY_2 then
		local packet = tree:add(roblox, buf(0))
		packet:add(field.id,        buf(0,1))
		packet:add(field.magic,     buf(1,16))
		packet:add(field.server_id, buf(17,8))
		packet:add(field.security,  buf(25,1))
		packet:add(field.cookie,    buf(26,4))
		packet:add(field.udp_port,  buf(30,2))
		packet:add(field.mtu_size,  buf(32,2))
		packet:add(field.security,  buf(34,1))

	elseif id == ID.ACKNOWLEDGED or id == ID.NOT_ACKNOWLEDGED then
		-- Each packet lists records that were ACK'd or NAK'd. The record
		-- count is big-endian (probably an oversight), while record numbers
		-- are little-endian.
		local packet = tree:add(roblox, buf(0))
		packet:add(field.id, buf(0,1))

		local records = packet:add(field.ack_records, buf(1))
		records:set_text("Records:")
		records:add(field.ack_record_count, buf(1,2))

		local o = 3
		for i = 1, buf(1,2):uint() do
			local ranged = buf(o,1):uint() == 0
			if ranged then
				local record = records:add(field.record, buf(o,7))
				record:add(field.record_single, buf(o,1))
				o = o + 1
				record:set_text("[" .. i-1 .. "] Record: " .. buf(o,3):le_uint() .. "-" .. buf(o+3,3):le_uint())
				record:add_le(field.record_min, buf(o,3))
				record:add_le(field.record_max, buf(o+3,3))
				o = o + 6
			else
				local record = records:add(field.record, buf(o,4))
				record:add(field.record_single, buf(o,1))
				o = o + 1
				record:set_text("[" .. i-1 .. "] Record: " .. buf(o,3):le_uint())
				record:add_le(field.record_min, buf(o,3))
				record:add_le(field.record_max, buf(o,3))
				o = o + 3
			end
		end

	elseif id == ID.CUSTOM_4 or id == ID.CUSTOM_C then
		-- These two types are the heavy lifters.
		local packet = tree:add(roblox, buf(0))
		packet:add(field.id, buf(0,1))
		packet:add_le(field.record_number, buf(1,3))
		packet:add(field.unknown, buf(4))

	else
		local packet = tree:add(roblox, buf(0))
		packet:add(field.id,      buf(0,1))
		packet:add(field.unknown, buf(1))
	end
end

-- TODO: Find a good constant that identifies Roblox traffic.
local udpPort = DissectorTable.get("udp.port")
udpPort:add(roblox.prefs.server_port, roblox)
