module Fitreader
  class BaseType #how to read the bytes
    attr_accessor :id, :type, :size, :unpack_type, :endian, :invalid
    def initialize(id,type,size,unpack,endian,invalid)
      @id=id
      @type=type
      @size=size
      @unpack_type=unpack
      @endian=endian
      @invalid=invalid
    end
    def unpack?
      unpack_type != nil
    end
    def enum?
      id == 0
    end
  end

  class FieldType
    attr_accessor :id, :type, :name, :scale, :offset
    def initialize(id,name,type,scale,offset)
      @id=id
      @name=name
      @type=type
      @scale=scale
      @offset=offset
    end
    def to_s
      "#{id}:
       name: #{name}
       type: #{type}
       scale: #{scale}
       offset: #{offset}"
    end
  end

  BASE_TYPES = {
    0=>BaseType.new(0, :enum, 1, nil,0,0xFF),
    1=>BaseType.new(1, :int, 1, 'c',0,0x7F),
    2=>BaseType.new(2, :int, 1, 'C',0,0xFF),
    3=>BaseType.new(3, :int, 2, 's',1,0x7FFF),
    4=>BaseType.new(4, :int, 2, 'S',1,0xFFFF),
    5=>BaseType.new(5, :int, 4, 'l',1,0x7FFFFFFF),
    6=>BaseType.new(6, :int, 4, 'L',1,0xFFFFFFFF),
    7=>BaseType.new(7, :string, 1, 'Z*',0,0x00),
    8=>BaseType.new(8, :float, 4, 'e',1,0xFFFFFFFF),
    9=>BaseType.new(9, :float, 8, 'E',1,0xFFFFFFFFFFFFFFFF),
    10=>BaseType.new(10, :int, 1, 'C',0,0x00),
    11=>BaseType.new(11, :int, 2, 'S',1,0x0000),
    12=>BaseType.new(12, :int, 4, 'L',1,0x0000000000),
    13=>BaseType.new(13, :byte, 1, nil,0,0xFF)
  }

  MESSAGE_FIELDS = {
    0 => {
      0=>FieldType.new(0,"filetype", :enum_file, 0, 0),
      1=>FieldType.new(1,"manufacturer", :enum_manufacturer, 0, 0),
      2=>FieldType.new(2,"garmin_product",:raw, 0, 0),
      3=>FieldType.new(3,"serial_number",:raw, 0, 0),
      4=>FieldType.new(4,"time_created",:date_time, 0, 0),
      5=>FieldType.new(5,"number",:raw, 0, 0),
      8=>FieldType.new(8,"product_name",:raw, 0, 0)
    },
    3 => {
      254=>FieldType.new(254,"message_index",:message_index, 0, 0),
      0=>FieldType.new(0,"friendly_name",:string, 0, 0),
      1=>FieldType.new(1,"gender",:enum_gender, 0, 0),
      2=>FieldType.new(2,"age",:raw, 0, 0),
      3=>FieldType.new(3,"height",:uint8, 100, 0),
      4=>FieldType.new(4,"weight",:uint16, 10, 0),
      5=>FieldType.new(5,"language",:enum_language, 0, 0),
      6=>FieldType.new(6,"elev_setting",:enum_display_measure, 0, 0),
      7=>FieldType.new(7,"weight_setting",:enum_display_measure, 0, 0),
      8=>FieldType.new(8,"resting_heart_rate",:uint8, 0, 0),
      9=>FieldType.new(9,"default_max_running_heart_rate",:uint8, 0, 0),
      10=>FieldType.new(10,"default_max_biking_heart_rate",:uint8, 0, 0),
      11=>FieldType.new(11,"default_max_heart_rate",:uint8, 0, 0),
      12=>FieldType.new(12,"hr_setting",:enum_display_heart, 0, 0),
      13=>FieldType.new(13,"speed_setting",:enum_display_measure, 0, 0),
      14=>FieldType.new(14,"dist_setting",:enum_display_measure, 0, 0),
      16=>FieldType.new(16,"power_setting",:enum_display_power, 0, 0),
      17=>FieldType.new(17,"activity_class",:enum_activity_class, 0, 0),
      18=>FieldType.new(18,"position_setting",:enum_display_position, 0, 0),
      21=>FieldType.new(21,"temperature_setting",:enum_display_measure, 0, 0),
      22=>FieldType.new(22,"local_id",:user_local_id, 0, 0),
      23=>FieldType.new(23,"global_id",:byte, 0, 0),
      30=>FieldType.new(30,"height_setting",:enum_display_measure, 0, 0)
    },
    6 => {
      254=>FieldType.new(254,"message_index",:message_index, 0, 0),
      0=>FieldType.new(0,"name",:string, 0, 0),
      1=>FieldType.new(1,"sport",:enum_sport, 0, 0),
      2=>FieldType.new(2,"sub_sport",:enum_sub_sport, 0, 0),
      3=>FieldType.new(3,"odometer",:uint32, 100, 0),
      4=>FieldType.new(4,"bike_spd_ant_id",:uint16z, 0, 0),
      5=>FieldType.new(5,"bike_cad_ant_id",:uint16z, 0, 0),
      6=>FieldType.new(6,"bike_spdcad_ant_id",:uint16z, 0, 0),
      7=>FieldType.new(7,"bike_power_ant_id",:uint16z, 0, 0),
      8=>FieldType.new(8,"custom_wheelsize",:uint16, 1000, 0),
      9=>FieldType.new(9,"auto_wheelsize",:uint16, 1000, 0),
      10=>FieldType.new(10,"bike_weight",:uint16, 10, 0),
      11=>FieldType.new(11,"power_cal_factor",:uint16, 10, 0),
      12=>FieldType.new(12,"auto_wheel_cal",:bool, 0, 0),
      13=>FieldType.new(13,"auto_power_zero",:bool, 0, 0),
      14=>FieldType.new(14,"id",:uint8, 0, 0),
      15=>FieldType.new(15,"spd_enabled",:bool, 0, 0),
      16=>FieldType.new(16,"cad_enabled",:bool, 0, 0),
      17=>FieldType.new(17,"spdcad_enabled",:bool, 0, 0),
      18=>FieldType.new(18,"power_enabled",:bool, 0, 0),
      19=>FieldType.new(19,"crank_length",:uint8, 2, 0),
      20=>FieldType.new(20,"enabled",:bool, 0, 0),
      21=>FieldType.new(21,"bike_spd_ant_id_trans_type",:uint8z, 0, 0),
      22=>FieldType.new(22,"bike_cad_ant_id_trans_type",:uint8z, 0, 0),
      23=>FieldType.new(23,"bike_spdcad_ant_id_trans_type",:uint8z, 0, 0),
      24=>FieldType.new(24,"bike_power_ant_id_trans_type",:uint8z, 0, 0)
    },
    7 => {
      1=>FieldType.new(1,"max_heart_rate",:uint8,0,0),
      2=>FieldType.new(2,"threshold_heart_rate",:uint8,0,0),
      3=>FieldType.new(3,"functional_threshold_power",:uint16,0,0),
      5=>FieldType.new(5,"hr_calc_type",:hr_zone_calc,0,0),
      7=>FieldType.new(7,"pwr_calc_type",:pwr_zone_calc,0,0)
    },
    18 => {
      254=>FieldType.new(254,"message_index",:message_index,0,0),
      253=>FieldType.new(253,"timestamp",:date_time,0,0),
      0=>FieldType.new(0,"event",:enum_event,0,0),
      1=>FieldType.new(1,"event_type",:enum_event_type,0,0),
      2=>FieldType.new(2,"start_time",:date_time,0,0),
      3=>FieldType.new(3,"start_position_lat",:coordinates,0,0),
      4=>FieldType.new(4,"start_position_long",:coordinates,0,0),
      5=>FieldType.new(5,"sport",:enum_sport,0,0),
      6=>FieldType.new(6,"sub_sport",:enum_sub_sport,0,0),
      7=>FieldType.new(7,"total_elapsed_time",:uint32,1000,0),
      8=>FieldType.new(8,"total_timer_time",:uint32,1000,0),
      9=>FieldType.new(9,"total_distance",:uint32,100,0),
      10=>FieldType.new(10,"total_cycles",:uint32,0,0),
      11=>FieldType.new(11,"total_calories",:uint16,0,0),
      13=>FieldType.new(13,"total_fat_calories",:uint16,0,0),
      14=>FieldType.new(14,"avg_speed",:uint16,1000,0),
      15=>FieldType.new(15,"max_speed",:uint16,1000,0),
      16=>FieldType.new(16,"avg_heart_rate",:uint8,0,0),
      17=>FieldType.new(17,"max_heart_rate",:uint8,0,0),
      18=>FieldType.new(18,"avg_cadence",:uint8,0,0),
      19=>FieldType.new(19,"max_cadence",:uint8,0,0),
      20=>FieldType.new(20,"avg_power",:uint16,0,0),
      21=>FieldType.new(21,"max_power",:uint16,0,0),
      22=>FieldType.new(22,"total_ascent",:uint16,0,0),
      23=>FieldType.new(23,"total_descent",:uint16,0,0),
      24=>FieldType.new(24,"total_training_effect",:uint8,10,0),
      25=>FieldType.new(25,"first_lap_index",:uint16,0,0),
      26=>FieldType.new(26,"num_laps",:uint16,0,0),
      27=>FieldType.new(27,"event_group",:uint8,0,0),
      28=>FieldType.new(28,"trigger",:enum_session_trigger,0,0),
      29=>FieldType.new(29,"nec_lat",:coordinates,0,0),
      30=>FieldType.new(30,"nec_long",:coordinates,0,0),
      31=>FieldType.new(31,"swc_lat",:coordinates,0,0),
      32=>FieldType.new(32,"swc_long",:coordinates,0,0),
      34=>FieldType.new(34,"normalized_power",:uint16,0,0),
      35=>FieldType.new(35,"training_stress_score",:uint16,10,0),
      36=>FieldType.new(36,"intensity_factor",:uint16,1000,0),
      37=>FieldType.new(37,"left_right_balance",:left_right_balance_100,0,0),
      41=>FieldType.new(41,"avg_stroke_count",:uint32,10,0),
      42=>FieldType.new(42,"avg_stroke_distance",:uint16,100,0),
      44=>FieldType.new(44,"pool_length",:uint16,100,0),
      45=>FieldType.new(45,"threshold_power",:uint16,0,0),
      46=>FieldType.new(46,"pool_length_unit",:enum_display_measure,0,0),
      47=>FieldType.new(47,"num_active_lengths",:uint16,0,0),
      48=>FieldType.new(48,"total_work",:uint32,0,0),
      49=>FieldType.new(49,"avg_altitude",:uint16,5,0),
      50=>FieldType.new(50,"max_altitude",:uint16,5,0),
      51=>FieldType.new(51,"gps_accuracy",:uint8,0,0),
      52=>FieldType.new(52,"avg_grade",:sint16,100,0),
      53=>FieldType.new(53,"avg_pos_grade",:sint16,100,0),
      54=>FieldType.new(54,"avg_neg_grade",:sint16,100,0),
      55=>FieldType.new(55,"max_pos_grade",:sint16,100,0),
      56=>FieldType.new(56,"max_neg_grade",:sint16,100,0),
      57=>FieldType.new(57,"avg_temperature",:sint8,0,0),
      58=>FieldType.new(58,"max_temperature",:sint8,0,0),
      59=>FieldType.new(59,"total_moving_time",:uint32,1000,0),
      60=>FieldType.new(60,"avg_pos_vertical_speed",:sint16,1000,0),
      61=>FieldType.new(61,"avg_neg_vertical_speed",:sint16,1000,0),
      62=>FieldType.new(62,"max_pos_vertical_speed",:sint16,1000,0),
      63=>FieldType.new(63,"max_neg_vertical_speed",:sint16,1000,0),
      64=>FieldType.new(64,"min_heart_rate",:uint8,0,0),
      65=>FieldType.new(65,"time_in_hr_zone",:uint32,1000,0),
      66=>FieldType.new(66,"time_in_speed_zone",:uint32,1000,0),
      67=>FieldType.new(67,"time_in_cadence_zone",:uint32,1000,0),
      68=>FieldType.new(68,"time_in_power_zone",:uint32,1000,0),
      69=>FieldType.new(69,"avg_lap_time",:uint32,1000,0),
      70=>FieldType.new(70,"best_lap_index",:uint16,0,0),
      71=>FieldType.new(71,"min_altitude",:uint16,5,500),
      82=>FieldType.new(82,"player_score",:uint16,0,0),
      83=>FieldType.new(83,"opponent_score",:uint16,0,0),
      84=>FieldType.new(84,"opponent_name",:string,0,0),
      85=>FieldType.new(85,"stroke_count",:uint16,0,0),
      86=>FieldType.new(86,"zone_count",:uint16,0,0),
      87=>FieldType.new(87,"max_ball_speed",:uint16,100,0),
      88=>FieldType.new(88,"avg_ball_speed",:uint16,100,0),
      89=>FieldType.new(89,"avg_vertical_oscillation",:uint16,10,0),
      90=>FieldType.new(90,"avg_stance_time_percent",:uint16,100,0),
      91=>FieldType.new(91,"avg_stance_time",:uint16,10,0),
      92=>FieldType.new(92,"avg_fractional_cadence",:uint8,128,0),
      93=>FieldType.new(93,"max_fractional_cadence",:uint8,128,0),
      94=>FieldType.new(94,"total_fractional_cycles",:uint8,128,0),
      95=>FieldType.new(95,"avg_total_hemoglobin_conc",:uint16,100,0),
      96=>FieldType.new(96,"min_total_hemoglobin_conc",:uint16,100,0),
      97=>FieldType.new(97,"max_total_hemoglobin_conc",:uint16,100,0),
      98=>FieldType.new(98,"avg_saturated_hemoglobin_percent",:uint16,10,0),
      99=>FieldType.new(99,"min_saturated_hemoglobin_percent",:uint16,10,0),
      100=>FieldType.new(100,"max_saturated_hemoglobin_percent",:uint16,10,0),
      101=>FieldType.new(101,"avg_left_torque_effectiveness",:uint8,2,0),
      102=>FieldType.new(102,"avg_right_torque_effectiveness",:uint8,2,0),
      103=>FieldType.new(103,"avg_left_pedal_smoothness",:uint8,2,0),
      104=>FieldType.new(104,"avg_right_pedal_smoothness",:uint8,2,0),
      105=>FieldType.new(105,"avg_combined_pedal_smoothness",:uint8,2,0),
      107=>FieldType.new(107,"num_front_gear_changes",:uint16,0,0),
      108=>FieldType.new(108,"num_rear_gear_changes",:uint16,0,0),
      111=>FieldType.new(111,"sport_index",:uint8,0,0),
      112=>FieldType.new(112,"time_standing",:uint32,1000,0),
      113=>FieldType.new(113,"stand_count",:uint16,0,0),
      114=>FieldType.new(114,"avg_left_pco",:sint8,0,0),
      115=>FieldType.new(115,"avg_right_pco",:sint8,0,0),
      116=>FieldType.new(116,"avg_left_power_phase",:uint8,0.7111111,0),
      117=>FieldType.new(117,"avg_left_power_phase_peak",:uint8,0.7111111,0),
      118=>FieldType.new(118,"avg_right_power_phase",:uint8,0.7111111,0),
      119=>FieldType.new(119,"avg_right_power_phase_peak",:uint8,0.7111111,0),
      120=>FieldType.new(120,"avg_power_position",:uint16,0,0),
      121=>FieldType.new(121,"max_power_position",:uint16,0,0),
      122=>FieldType.new(122,"avg_cadence_position",:uint8,0,0),
      123=>FieldType.new(123,"max_cadence_position",:uint8,0,0),
      124=>FieldType.new(124,"enhanced_avg_speed",:uint32,1000,0),
      125=>FieldType.new(125,"enhanced_max_speed",:uint32,1000,0),
      126=>FieldType.new(126,"enhanced_avg_altitude",:uint32,5,500),
      127=>FieldType.new(127,"enhanced_min_altitude",:uint32,5,500),
      128=>FieldType.new(128,"enhanced_max_altitude",:uint32,5,500),
      129=>FieldType.new(129,"avg_lev_motor_power",:uint16,0,0),
      130=>FieldType.new(130,"max_lev_motor_power",:uint16,0,0),
      131=>FieldType.new(131,"lev_battery_consumption",:uint8,2,0)
    },
    19 => {
      254=>FieldType.new(254,"message_index",:message_index,0,0),
      253=>FieldType.new(253,"timestamp",:date_time,0,0),
      0=>FieldType.new(0,"event",:enum_event,0,0),
      1=>FieldType.new(1,"event_type",:enum_event_type,0,0),
      2=>FieldType.new(2,"start_time",:date_time,0,0),
      3=>FieldType.new(3,"start_position_lat",:coordinates,0,0),
      4=>FieldType.new(4,"start_position_long",:coordinates,0,0),
      5=>FieldType.new(5,"end_position_lat",:coordinates,0,0),
      6=>FieldType.new(6,"end_position_long",:coordinates,0,0),
      7=>FieldType.new(7,"total_elapsed_time",:uint32,1000,0),
      8=>FieldType.new(8,"total_timer_time",:uint32,1000,0),
      9=>FieldType.new(9,"total_distance",:uint32,100,0),
      10=>FieldType.new(10,"total_cycles",:uint32,0,0),
      11=>FieldType.new(11,"total_calories",:uint16,0,0),
      12=>FieldType.new(12,"total_fat_calories",:uint16,0,0),
      13=>FieldType.new(13,"avg_speed",:uint16,1000,0),
      14=>FieldType.new(14,"max_speed",:uint16,1000,0),
      15=>FieldType.new(15,"avg_heart_rate",:uint8,0,0),
      16=>FieldType.new(16,"max_heart_rate",:uint8,0,0),
      17=>FieldType.new(17,"avg_cadence",:uint8,0,0),
      18=>FieldType.new(18,"max_cadence",:uint8,0,0),
      19=>FieldType.new(19,"avg_power",:uint16,0,0),
      20=>FieldType.new(20,"max_power",:uint16,0,0),
      21=>FieldType.new(21,"total_ascent",:uint16,0,0),
      22=>FieldType.new(22,"total_descent",:uint16,0,0),
      23=>FieldType.new(23,"intensity",:enum_intensity,0,0),
      24=>FieldType.new(24,"lap_trigger",:enum_lap_trigger,0,0),
      25=>FieldType.new(25,"sport",:enum_sport,0,0),
      26=>FieldType.new(26,"event_group",:uint8,0,0),
      27=>FieldType.new(27,"nec_lat",:coordinates,0,0),
      28=>FieldType.new(28,"nec_long",:coordinates,0,0),
      29=>FieldType.new(29,"swc_lat",:coordinates,0,0),
      30=>FieldType.new(30,"swc_long",:coordinates,0,0),
      32=>FieldType.new(32,"num_lengths",:uint16,0,0),
      33=>FieldType.new(33,"normalized_power",:uint16,0,0),
      34=>FieldType.new(34,"left_right_balance",:left_right_balance_100,0,0),
      35=>FieldType.new(35,"first_length_index",:uint16,0,0),
      37=>FieldType.new(37,"avg_stroke_distance",:uint16,100,0),
      38=>FieldType.new(38,"swim_stroke",:enum_swim_stroke,0,0),
      39=>FieldType.new(39,"sub_sport",:enum_sub_sport,0,0),
      40=>FieldType.new(40,"num_active_lengths",:uint16,0,0),
      41=>FieldType.new(41,"total_work",:uint32,0,0),
      42=>FieldType.new(42,"avg_altitude",:uint16,5,500),
      43=>FieldType.new(43,"max_altitude",:uint16,5,500),
      44=>FieldType.new(44,"gps_accuracy",:uint8,0,0),
      45=>FieldType.new(45,"avg_grade",:sint16,100,0),
      46=>FieldType.new(46,"avg_pos_grade",:sint16,100,0),
      47=>FieldType.new(47,"avg_neg_grade",:sint16,100,0),
      48=>FieldType.new(48,"max_pos_grade",:sint16,100,0),
      49=>FieldType.new(49,"max_neg_grade",:sint16,100,0),
      50=>FieldType.new(50,"avg_temperature",:sint8,0,0),
      51=>FieldType.new(51,"max_temperature",:sint8,0,0),
      52=>FieldType.new(52,"total_moving_time",:uint32,1000,0),
      53=>FieldType.new(53,"avg_pos_vertical_speed",:sint16,1000,0),
      54=>FieldType.new(54,"avg_neg_vertical_speed",:sint16,1000,0),
      55=>FieldType.new(55,"max_pos_vertical_speed",:sint16,1000,0),
      56=>FieldType.new(56,"max_neg_vertical_speed",:sint16,1000,0),
      57=>FieldType.new(57,"time_in_hr_zone",:uint32,1000,0),
      58=>FieldType.new(58,"time_in_speed_zone",:uint32,1000,0),
      59=>FieldType.new(59,"time_in_cadence_zone",:uint32,1000,0),
      60=>FieldType.new(60,"time_in_power_zone",:uint32,1000,0),
      61=>FieldType.new(61,"repetition_num",:uint16,0,0),
      62=>FieldType.new(62,"min_altitude",:uint16,5,500),
      63=>FieldType.new(63,"min_heart_rate",:uint8,0,0),
      71=>FieldType.new(71,"wkt_step_index",:message_index,0,0),
      74=>FieldType.new(74,"opponent_score",:uint16,0,0),
      75=>FieldType.new(75,"stroke_count",:uint16,0,0),
      76=>FieldType.new(76,"zone_count",:uint16,0,0),
      77=>FieldType.new(77,"avg_vertical_oscillation",:uint16,10,0),
      78=>FieldType.new(78,"avg_stance_time_percent",:uint16,100,0),
      79=>FieldType.new(79,"avg_stance_time",:uint16,10,0),
      80=>FieldType.new(80,"avg_fractional_cadence",:uint8,128,0),
      81=>FieldType.new(81,"max_fractional_cadence",:uint8,128,0),
      82=>FieldType.new(82,"total_fractional_cycles",:uint8,128,0),
      83=>FieldType.new(83,"player_score",:uint16,0,0),
      84=>FieldType.new(84,"avg_total_hemoglobin_conc",:uint16,100,0),
      85=>FieldType.new(85,"min_total_hemoglobin_conc",:uint16,100,0),
      86=>FieldType.new(86,"max_total_hemoglobin_conc",:uint16,100,0),
      87=>FieldType.new(87,"avg_saturated_hemoglobin_percent",:uint16,10,0),
      88=>FieldType.new(88,"min_saturated_hemoglobin_percent",:uint16,10,0),
      89=>FieldType.new(89,"max_saturated_hemoglobin_percent",:uint16,10,0),
      91=>FieldType.new(91,"avg_left_torque_effectiveness",:uint8,2,0),
      92=>FieldType.new(92,"avg_right_torque_effectiveness",:uint8,2,0),
      93=>FieldType.new(93,"avg_left_pedal_smoothness",:uint8,2,0),
      94=>FieldType.new(94,"avg_right_pedal_smoothness",:uint8,2,0),
      95=>FieldType.new(95,"avg_combined_pedal_smoothness",:uint8,2,0),
      96=>FieldType.new(96,"num_front_gear_changes",:uint16,0,0),
      97=>FieldType.new(97,"num_rear_gear_changes",:uint16,0,0),
      98=>FieldType.new(98,"time_standing",:uint32,1000,0),
      99=>FieldType.new(99,"stand_count",:uint16,0,0),
      100=>FieldType.new(100,"avg_left_pco",:sint8,0,0),
      101=>FieldType.new(101,"avg_right_pco",:sint8,0,0),
      102=>FieldType.new(102,"avg_left_power_phase",:uint8,0.7111111,0),
      103=>FieldType.new(103,"avg_left_power_phase_peak",:uint8,0.7111111,0),
      104=>FieldType.new(104,"avg_right_power_phase",:uint8,0.7111111,0),
      105=>FieldType.new(105,"avg_right_power_phase_peak",:uint8,0.7111111,0),
      106=>FieldType.new(106,"avg_power_position",:uint16,0,0),
      107=>FieldType.new(107,"max_power_position",:uint16,0,0),
      108=>FieldType.new(108,"avg_cadence_position",:uint8,0,0),
      109=>FieldType.new(109,"max_cadence_position",:uint8,0,0),
      110=>FieldType.new(110,"enhanced_avg_speed",:uint32,1000,0),
      111=>FieldType.new(111,"enhanced_max_speed",:uint32,1000,0),
      112=>FieldType.new(112,"enhanced_avg_altitude",:uint32,5,500),
      113=>FieldType.new(113,"enhanced_min_altitude",:uint32,5,500),
      114=>FieldType.new(114,"enhanced_max_altitude",:uint32,5,500),
      115=>FieldType.new(115,"avg_lev_motor_power",:uint16,0,0),
      116=>FieldType.new(116,"max_lev_motor_power",:uint16,0,0),
      117=>FieldType.new(117,"lev_battery_consumption",:uint8,2,0)
    },
    20 => {
      253=>FieldType.new(253,"timestamp",:date_time,0,0),
      0=>FieldType.new(0,"position_lat",:coordinates,0,0),
      1=>FieldType.new(1,"position_long",:coordinates,0,0),
      2=>FieldType.new(2,"altitude",:uint16,5,500),
      3=>FieldType.new(3,"heart_rate",:uint8,0,0),
      4=>FieldType.new(4,"cadence",:uint8,0,0),
      5=>FieldType.new(5,"distance",:uint32,100,0),
      6=>FieldType.new(6,"speed",:uint16,1000,0),
      7=>FieldType.new(7,"power",:uint16,0,0),
      8=>FieldType.new(8,"compressed_speed_distance",:byte,100,0),
      9=>FieldType.new(9,"grade",:sint16,100,0),
      10=>FieldType.new(10,"resistance",:uint8,0,0),
      11=>FieldType.new(11,"time_from_course",:sint32,1000,0),
      12=>FieldType.new(12,"cycle_length",:uint8,100,0),
      13=>FieldType.new(13,"temperature",:sint8,0,0),
      17=>FieldType.new(17,"speed_1s",:uint8,16,0),
      18=>FieldType.new(18,"cycles",:uint8,0,0),
      19=>FieldType.new(19,"total_cycles",:uint32,0,0),
      28=>FieldType.new(28,"compressed_accumulated_power",:uint16,0,0),
      29=>FieldType.new(29,"accumulated_power",:uint32,0,0),
      30=>FieldType.new(30,"left_right_balance",:left_right_balance,0,0),
      31=>FieldType.new(31,"gps_accuracy",:uint8,0,0),
      32=>FieldType.new(32,"vertical_speed",:sint16,1000,0),
      33=>FieldType.new(33,"calories",:uint16,0,0),
      39=>FieldType.new(39,"vertical_oscillation",:uint16,10,0),
      40=>FieldType.new(40,"stance_time_percent",:uint16,100,0),
      41=>FieldType.new(41,"stance_time",:uint16,10,0),
      42=>FieldType.new(42,"activity_type",:activity_type,0,0),
      43=>FieldType.new(43,"left_torque_effectiveness",:uint8,2,0),
      44=>FieldType.new(44,"right_torque_effectiveness",:uint8,2,0),
      45=>FieldType.new(45,"left_pedal_smoothness",:uint8,2,0),
      46=>FieldType.new(46,"right_pedal_smoothness",:uint8,2,0),
      47=>FieldType.new(47,"combined_pedal_smoothness",:uint8,2,0),
      48=>FieldType.new(48,"time128",:uint8,128,0),
      49=>FieldType.new(49,"stroke_type",:stroke_type,0,0),
      50=>FieldType.new(50,"zone",:uint8,0,0),
      51=>FieldType.new(51,"ball_speed",:uint16,100,0),
      52=>FieldType.new(52,"cadence256",:uint16,256,0),
      53=>FieldType.new(53,"fractional_cadence",:uint8,128,0),
      54=>FieldType.new(54,"total_hemoglobin_conc",:uint16,100,0),
      55=>FieldType.new(55,"total_hemoglobin_conc_min",:uint16,100,0),
      56=>FieldType.new(56,"total_hemoglobin_conc_max",:uint16,100,0),
      57=>FieldType.new(57,"saturated_hemoglobin_percent",:uint16,10,0),
      58=>FieldType.new(58,"saturated_hemoglobin_percent_min",:uint16,10,0),
      59=>FieldType.new(59,"saturated_hemoglobin_percent_max",:uint16,10,0),
      62=>FieldType.new(62,"device_index",:device_index,0,0),
      67=>FieldType.new(67,"left_pco",:sint8,0,0),
      68=>FieldType.new(68,"right_pco",:sint8,0,0),
      69=>FieldType.new(69,"left_power_phase",:uint8,0.7111111,0),
      70=>FieldType.new(70,"left_power_phase_peak",:uint8,0.7111111,0),
      71=>FieldType.new(71,"right_power_phase",:uint8,0.7111111,0),
      72=>FieldType.new(72,"right_power_phase_peak",:uint8,0.7111111,0),
      73=>FieldType.new(73,"enhanced_speed",:uint32,1000,0),
      78=>FieldType.new(78,"enhanced_altitude",:uint32,5,500),
      81=>FieldType.new(81,"battery_soc",:uint8,2,0),
      82=>FieldType.new(82,"motor_power",:uint16,0,0)
    },
    21 => {
      253=>FieldType.new(253,"timestamp",:date_time,0,0),
      0=>FieldType.new(0,"event",:enum_event, 0, 0),
      1=>FieldType.new(1,"event_type",:enum_event_type, 0, 0),
      2=>FieldType.new(2,"data16",:uint16, 0, 0),
      3=>FieldType.new(3,"data",:uint32, 0, 0),
      4=>FieldType.new(4,"event_group",:uint8, 0, 0),
      7=>FieldType.new(7,"score",:uint16, 0, 0),
      8=>FieldType.new(8,"opponent_score",:uint16, 0, 0),
      9=>FieldType.new(9,"front_gear_num",:uint8z, 0, 0),
      10=>FieldType.new(10,"front_gear",:uint8z, 0, 0),
      11=>FieldType.new(11,"rear_gear_num",:uint8z, 0, 0),
      12=>FieldType.new(12,"rear_gear",:uint8z, 0, 0),
      13=>FieldType.new(13,"device_index",:raw, 0, 0)
    },
    22 => {
      253=>FieldType.new(253,"timestamp",:date_time, 0, 0),
      0=>FieldType.new(0,"speed",:device_index, 0, 0),
      1=>FieldType.new(1,"distance",:device_index, 0, 0),
      2=>FieldType.new(2,"cadence",:device_index, 0, 0),
      3=>FieldType.new(3,"altitude",:device_index, 0, 0),
      4=>FieldType.new(4,"heart",:device_index, 0, 0)
    },
    23 => {
      253=>FieldType.new(253,"timestamp",:date_time, 0, 0),
      0=>FieldType.new(0,"device_index",:device_index, 0, 0),
      1=>FieldType.new(1,"device_type",:uint8, 0, 0),
      2=>FieldType.new(2,"manufacturer",:enum_manufacturer, 0, 0),
      3=>FieldType.new(3,"serial_number",:uint32z, 0, 0),
      4=>FieldType.new(4,"product",:uint16, 0, 0),
      5=>FieldType.new(5,"software_version",:uint16, 100, 0),
      6=>FieldType.new(6,"hardware_version",:uint8, 0, 0),
      7=>FieldType.new(7,"cum_operating_time",:uint32, 0, 0),
      10=>FieldType.new(10,"battery_voltage",:uint16, 256, 0),
      11=>FieldType.new(11,"battery_status",:enum_battery_status, 0, 0),
      18=>FieldType.new(18,"sensor_position",:enum_body_location, 0, 0),
      19=>FieldType.new(19,"descriptor",:string, 0, 0),
      20=>FieldType.new(20,"ant_transmission_type",:uint8z, 0, 0),
      21=>FieldType.new(21,"ant_device_number",:uint16z, 0, 0),
      22=>FieldType.new(22,"ant_network",:enum_ant_network, 0, 0),
      23=>FieldType.new(23,"Serial number", :raw, 0,0),
      24=>FieldType.new(23,"Sensor serial number", :raw, 0,0),
      25=>FieldType.new(25,"source_type",:enum_source_type, 0, 0),
      27=>FieldType.new(27,"product_name",:string, 0, 0)
    },
    34 => {
      253=>FieldType.new(253,"timestamp",:date_time,0,0),
      0=>FieldType.new(0,"total_timer_time",:uint32,0,0),
      1=>FieldType.new(1,"num_sessions",:uint16,0,0),
      2=>FieldType.new(2,"type",:enum_activity,0,0),
      3=>FieldType.new(3,"event",:enum_event,0,0),
      4=>FieldType.new(4,"event_type",:enum_event_type,0,0),
      5=>FieldType.new(5,"local_timestamp",:local_date_time,0,0),
      6=>FieldType.new(6,"event_group",:uint8,0,0)
    },
    49 => {
      0=>FieldType.new(0,"software_version",:uint16, 0, 0),
      1=>FieldType.new(1,"hardware_version",:uint8, 0, 0)
    },
    72 => {
      253=>FieldType.new(253,"timestamp",:date_time,0,0),
      0=>FieldType.new(0,"type",:enum_file,0,0),
      1=>FieldType.new(1,"manufacturer",:enum_manufacturer,0,0),
      2=>FieldType.new(2,"product",:uint16,0,0),
      3=>FieldType.new(3,"serial_number",:uint32z,0,0),
      4=>FieldType.new(4,"time_created",:date_time,0,0)
    },
    104 => {
      253=>FieldType.new(253,"timestamp",:date_time,0,0),
      0=>FieldType.new(0,"charge",:raw,0,0),
      2=>FieldType.new(2,"percent",:raw,0,0),
    },
    142 => {
      254=>FieldType.new(254,"message_index",:message_index,0,0),
      253=>FieldType.new(253,"timestamp",:date_time,0,0),
      0=>FieldType.new(0,"event",:event,0,0),
      1=>FieldType.new(1,"event_type",:event_type,0,0),
      2=>FieldType.new(2,"start_time",:date_time,0,0),
      3=>FieldType.new(3,"start_position_lat",:coordinates,0,0),
      4=>FieldType.new(4,"start_position_long",:coordinates,0,0),
      5=>FieldType.new(5,"end_position_lat",:coordinates,0,0),
      6=>FieldType.new(6,"end_position_long",:coordinates,0,0),
      7=>FieldType.new(7,"total_elapsed_time",:uint32,1000,0),
      8=>FieldType.new(8,"total_timer_time",:uint32,1000,0),
      9=>FieldType.new(9,"total_distance",:uint32,100,0),
      10=>FieldType.new(10,"total_cycles",:uint32,0,0),
      11=>FieldType.new(11,"total_calories",:uint16,0,0),
      12=>FieldType.new(12,"total_fat_calories",:uint16,0,0),
      13=>FieldType.new(13,"avg_speed",:uint16,1000,0),
      14=>FieldType.new(14,"max_speed",:uint16,1000,0),
      15=>FieldType.new(15,"avg_heart_rate",:uint8,0,0),
      16=>FieldType.new(16,"max_heart_rate",:uint8,0,0),
      17=>FieldType.new(17,"avg_cadence",:uint8,0,0),
      18=>FieldType.new(18,"max_cadence",:uint8,0,0),
      19=>FieldType.new(19,"avg_power",:uint16,0,0),
      20=>FieldType.new(20,"max_power",:uint16,0,0),
      21=>FieldType.new(21,"total_ascent",:uint16,0,0),
      22=>FieldType.new(22,"total_descent",:uint16,0,0),
      23=>FieldType.new(23,"sport",:sport,0,0),
      24=>FieldType.new(24,"event_group",:uint8,0,0),
      25=>FieldType.new(25,"nec_lat",:coordinates,0,0),
      26=>FieldType.new(26,"nec_long",:coordinates,0,0),
      27=>FieldType.new(27,"swc_lat",:coordinates,0,0),
      28=>FieldType.new(28,"swc_long",:coordinates,0,0),
      29=>FieldType.new(29,"name",:string,0,0),
      30=>FieldType.new(30,"normalized_power",:uint16,0,0),
      31=>FieldType.new(31,"left_right_balance",:left_right_balance_100,0,0),
      32=>FieldType.new(32,"sub_sport",:sub_sport,0,0),
      33=>FieldType.new(33,"total_work",:uint32,0,0),
      34=>FieldType.new(34,"avg_altitude",:uint16,5,500),
      35=>FieldType.new(35,"max_altitude",:uint16,5,500),
      36=>FieldType.new(36,"gps_accuracy",:uint8,0,0),
      37=>FieldType.new(37,"avg_grade",:sint16,100,0),
      38=>FieldType.new(38,"avg_pos_grade",:sint16,100,0),
      39=>FieldType.new(39,"avg_neg_grade",:sint16,100,0),
      40=>FieldType.new(40,"max_pos_grade",:sint16,100,0),
      41=>FieldType.new(41,"max_neg_grade",:sint16,100,0),
      42=>FieldType.new(42,"avg_temperature",:sint8,0,0),
      43=>FieldType.new(43,"max_temperature",:sint8,0,0),
      44=>FieldType.new(44,"total_moving_time",:uint32,1000,0),
      45=>FieldType.new(45,"avg_pos_vertical_speed",:sint16,1000,0),
      46=>FieldType.new(46,"avg_neg_vertical_speed",:sint16,1000,0),
      47=>FieldType.new(47,"max_pos_vertical_speed",:sint16,1000,0),
      48=>FieldType.new(48,"max_neg_vertical_speed",:sint16,1000,0),
      49=>FieldType.new(49,"time_in_hr_zone",:uint32,1000,0),
      50=>FieldType.new(50,"time_in_speed_zone",:uint32,1000,0),
      51=>FieldType.new(51,"time_in_cadence_zone",:uint32,1000,0),
      52=>FieldType.new(52,"time_in_power_zone",:uint32,1000,0),
      53=>FieldType.new(53,"repetition_num",:uint16,0,0),
      54=>FieldType.new(54,"min_altitude",:uint16,5,500),
      55=>FieldType.new(55,"min_heart_rate",:uint8,0,0),
      56=>FieldType.new(56,"active_time",:uint32,1000,0),
      57=>FieldType.new(57,"wkt_step_index",:message_index,0,0),
      58=>FieldType.new(58,"sport_event",:sport_event,0,0),
      59=>FieldType.new(59,"avg_left_torque_effectiveness",:uint8,2,0),
      60=>FieldType.new(60,"avg_right_torque_effectiveness",:uint8,2,0),
      61=>FieldType.new(61,"avg_left_pedal_smoothness",:uint8,2,0),
      62=>FieldType.new(62,"avg_right_pedal_smoothness",:uint8,2,0),
      63=>FieldType.new(63,"avg_combined_pedal_smoothness",:uint8,2,0),
      64=>FieldType.new(64,"status",:segment_lap_status,0,0),
      65=>FieldType.new(65,"uuid",:string,0,0),
      66=>FieldType.new(66,"avg_fractional_cadence",:uint8,128,0),
      67=>FieldType.new(67,"max_fractional_cadence",:uint8,128,0),
      68=>FieldType.new(68,"total_fractional_cycles",:uint8,128,0),
      69=>FieldType.new(69,"front_gear_shift_count",:uint16,0,0),
      70=>FieldType.new(70,"rear_gear_shift_count",:uint16,0,0),
      71=>FieldType.new(71,"time_standing",:uint32,1000,0),
      72=>FieldType.new(72,"stand_count",:uint16,0,0),
      73=>FieldType.new(73,"avg_left_pco",:sint8,0,0),
      74=>FieldType.new(74,"avg_right_pco",:sint8,0,0),
      75=>FieldType.new(75,"avg_left_power_phase",:uint8,0.7111111,0),
      76=>FieldType.new(76,"avg_left_power_phase_peak",:uint8,0.7111111,0),
      77=>FieldType.new(77,"avg_right_power_phase",:uint8,0.7111111,0),
      78=>FieldType.new(78,"avg_right_power_phase_peak",:uint8,0.7111111,0),
      79=>FieldType.new(79,"avg_power_position",:uint16,0,0),
      80=>FieldType.new(80,"max_power_position",:uint16,0,0),
      81=>FieldType.new(81,"avg_cadence_position",:uint8,0,0),
      82=>FieldType.new(82,"max_cadence_position",:uint8,0,0)
    },
    147 => {
      0=>FieldType.new(0,"Serial number", :raw, 0,0),
      2=>FieldType.new(2,"Name", :raw, 0,0),
      32=>FieldType.new(32,"Product", :raw, 0,0),
      34=>FieldType.new(34,"Software version", :raw, 0,0),
      254=>FieldType.new(254,"message_index",:message_index,0,0)
    }
  }

  UNDEFINED = {
    22 => {},
    79 => {},
    13 => {},
    104 => {},
    140 => {},
    113 => {}
  }
end
