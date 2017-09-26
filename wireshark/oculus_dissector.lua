local usb_packet = {
    IF_CLASS_UNKNOWN = 0xffff
}

local rift_irq = {
    SENSORS = 11
}

local rift_cmd_names = {
    [rift_irq.SENSORS] = "Sensor Data"
}

local rift = Proto("OpenHMD","Oculus Rift")

-- Protocol fields
local pf_irq_cmd = ProtoField.uint8("rift.cmd", "Command", base.DEC, rift_cmd_names)
local pf_sensor_num_samples = ProtoField.uint8("sensor.num_samples", "Number of samples")
local pf_sensor_num_samples_since_start = ProtoField.uint8("sensor.num_samples_since_start", "Number of samples since start")
local pf_sensor_timestamp_dk2 = ProtoField.uint32("sensor.timestamp", "Timestamp")
local pf_sensor_last_command_id = ProtoField.uint16("sensor.last_command_id", "Last command ID")
local pf_sensor_temperature = ProtoField.uint16("sensor.temperature", "Temperature")
local pf_sensor_mag = ProtoField.bytes("sensor.mag", "Magnetic field")
local pf_sensor_mag_x = ProtoField.int16("sensor.mag.x", "Mag X")
local pf_sensor_mag_y = ProtoField.int16("sensor.mag.y", "Mag Y")
local pf_sensor_mag_z = ProtoField.int16("sensor.mag.z", "Mag Z")
local pf_sensor_sample_accel = ProtoField.bytes("sensor.sample.accel", "Accel")
local pf_sensor_sample_gyro = ProtoField.bytes("sensor.sample.gyro", "Gyro")

-- Register protocol fields
rift.fields = {
    pf_irq_cmd,
    pf_sensor_num_samples,
    pf_sensor_num_samples_since_start,
    pf_sensor_timestamp_dk2,
    pf_sensor_temperature,
    pf_sensor_last_command_id,
    pf_sensor_sample_accel,
    pf_sensor_sample_gyro,
    pf_sensor_mag,
    pf_sensor_mag_x,
    pf_sensor_mag_y,
    pf_sensor_mag_z
}

-- Fields
local irq_cmd_field = Field.new("rift.cmd")
local f_sensor_num_samples = Field.new("sensor.num_samples")

-- Debug function
local dprint = function(...)
    print(table.concat({"OculusRift Dissector:", ...}, " "))
end

-- Rift IRQ Dissectors
local function rift_dissect_sensor_data(tvbuf, pktinfo, tree)
    local sensortree = tree:add(tvbuf(1, 11), "Tracker sensor message")

    sensortree:add(pf_sensor_last_command_id,            tvbuf:range(1,2))
    sensortree:add(pf_sensor_num_samples,                tvbuf:range(3,1))
    sensortree:add_le(pf_sensor_num_samples_since_start, tvbuf:range(4,2))
    sensortree:add_le(pf_sensor_temperature,             tvbuf:range(6,2))
    sensortree:add_le(pf_sensor_timestamp_dk2,           tvbuf:range(8,4))

    local num_samples = math.min(f_sensor_num_samples()(), 2)
    local offset = 12

    -- Decode up to two samples
    for index=0,num_samples-1 do
        local sampletree = sensortree:add(tvbuf(offset, 16), "Sample " .. index)
        local acceltree = sampletree:add(pf_sensor_sample_accel, tvbuf:range(offset, 8))
        local gyrotree = sampletree:add(pf_sensor_sample_gyro, tvbuf:range(offset+8, 8))
        offset = offset + 16
    end

    -- Skip empty samples
    offset = offset + (2 - num_samples)*16
    local magtree = sensortree:add(pf_sensor_mag, tvbuf:range(offset, 6))
    magtree:add(pf_sensor_mag_x, tvbuf:range(offset, 2))
    magtree:add(pf_sensor_mag_y, tvbuf:range(offset+2, 2))
    magtree:add(pf_sensor_mag_z, tvbuf:range(offset+4, 2))

    pktinfo.cols.info:set("Sensor Data")
end

-- IRQ Dissector table
local rift_irq_dissectors = {
    [rift_irq.SENSORS] = rift_dissect_sensor_data
}

-- Dissector entry point
function rift.dissector(tvbuf, pktinfo, root)
    local pktlen = tvbuf:reported_length_remaining()

    if not pktlen == 64 then
        return
    end

    pktinfo.cols.protocol:set("Oculus Rift")
    local tree = root:add(rift, tvbuf:range(0, pktlen))
    tree:add(pf_irq_cmd, tvbuf:range(0,1))

    local cmd = irq_cmd_field()()
    local dissector = rift_irq_dissectors[cmd]

    if dissector then
        dissector(tvbuf, pktinfo, tree)
    else
        pktinfo.cols.info:set("Unknown (" .. cmd .. ")")
    end

    return pktlen
end

DissectorTable.get("usb.interrupt"):add(0xffff, rift)
