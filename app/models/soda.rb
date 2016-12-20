class Soda

  STATES = {
    "Alabama" => "rpcs-x4hb",
  	"Alaska" => "6cra-6bsr",
  	"Arizona" => "rhfm-rcgr",
  	"Arkansas" => "iwsf-v24f",
  	"California" => "pvah-jb5g",
  	"Colorado" => "6hcc-vvir",
  	"Connecticut" => "mxju-48pr",
  	"Delaware" => "tfrh-eycc",
  	"District of Columbia" => "9fsr-q9if",
  	"Florida" => "nvuq-vvhu",
  	"Georgia" => "bdyn-jgqi",
  	"Hawaii" => "r8u9-52wb",
  	"Idaho" => "udhx-7h28",
  	"Illinois" => "gdxd-nqvh",
  	"Indiana" => "3yzb-q8hi",
  	"Iowa" => "dhsi-bwde",
  	"Kansas" => "fhr3-sna2",
  	"Kentucky" => "52xd-dn42",
  	"Louisiana" => "mby6-c5s9",
  	"Maine" => "mi8z-tz2k",
  	"Maryland" => "xusy-5u5f",
  	"Massachusetts" => "k4m6-dw2r",
  	"Michigan" => "49da-3f5i",
  	"Minnesota" => "frmt-xidf",
  	"Mississippi" => "nn3v-3j5a",
  	"Missouri" => "4pjc-c4n3",
  	"Montana" => "xi6a-f34f",
  	"Nebraska" => "8sqv-33jb",
  	"Nevada" => "ht3b-dbkk",
  	"New Hampshire" => "hb57-sew3",
  	"New Jersey" => "s9g8-ajpt",
  	"New Mexico" => "5ari-z7i6",
  	"New York" => "ezit-atvu",
  	"North Carolina" => "3tw3-njaz",
  	"North Dakota" => "9cha-w57y",
  	"Ohio" => "tbag-ib8t",
  	"Oklahoma" => "68i8-6as4",
  	"Oregon" => "mu9b-htfk",
  	"Pennsylvania" => "ph4u-94ai",
  	"Rhode Island" => "2ega-f9dr",
  	"South Carolina" => "pn6q-57yk",
  	"South Dakota" => "hmdh-n3je",
  	"Tennessee" => "wezb-ypmu",
  	"Texas" => "cwmr-tcae",
  	"Utah" => "xhyh-88mc",
  	"Vermont" => "5cjz-kf32",
  	"Virginia" => "x5fr-gthr",
  	"Washington" => "ead4-6pvk",
  	"West Virginia" => "u459-ybv3",
  	"Wisconsin" => "pqxu-7nbv",
  	"Wyoming" => "24xw-zi2q"
  }

  def initialize
    @client = SODA::Client.new({domain: "data.nationalservice.gov", app_token: Rails.application.secrets.soda_key})
  end

  def search
    STATES.map do |state, dataset|
      state_stat = StateStat.find_by(state: state)
      if state_stat
        update_db(state_stat)
      else
        add_to_db(state, dataset)
      end
    end
  end

  def add_to_db(state, dataset)
    update_db(StateStat.create(state: state, dataset: dataset, metrics: []))
  end

  def update_db(state)
    records = @client.get(state.dataset, {:$limit => 5000})
    metrics = []
    records.each do |record|
      metrics << [record.value_name, (record.metric.to_f * 100).round(2)]
    end
    state.update(metrics: metrics)
  end

end
