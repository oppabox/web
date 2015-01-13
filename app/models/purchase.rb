class Purchase < ActiveRecord::Base
  include AllatUtil
  has_many :orders
  belongs_to  :user
  # validates :reference_number, uniqueness: true
  # before_save :set_reference_number

  AT_CROSS_KEY = "efb017021539bb77f652893aca3f05a1"     #설정필요 [사이트 참조 - http://www.allatpay.com/servlet/AllatBiz/support/sp_install_guide_scriptapi.jsp#shop]
  AT_KRW_SHOP_ID   = "oppabox"          #설정필요
  AT_USD_SHOP_ID   = "usd_oppbox"       #설정필요

  STATUSES = {
    PURCHASE_ORDERING => '주문중', 
    PURCHASE_PAID => '결제완료',
    PURCHASE_PENDING => '무통장 확인',
    PURCHASE_ON_DELIVERY => '배송중',
    PURCHASE_DONE => '배송완료'
  }

  scope :valid,              -> { where.not(status: PURCHASE_ORDERING) }
  scope :purchase_paid,      -> { where(status: PURCHASE_PAID) }
  scope :purchase_pending,   -> { where(status: PURCHASE_PENDING) }
  scope :user_kr,            -> { Purchase.joins(:user).where("users.country = ?", "KR")}
  scope :user_not_kr,        -> { Purchase.joins(:user).where("users.country != ?", "KR")}


  def set_reference_number
    # 'P' + timestamp(15) + '-' + purchase_id(8)
    str = 'P'
    str += DateTime.current().strftime("%Y%m%d-%H%M%S")
    str += '-'
    str += self.id.to_s.rjust(8, '0')
    self.reference_number = str
  end

  def tmp_set_reference_number
    # 'P' + timestamp(15) + '-' + purchase_id(8)
    str = 'P'
    str += DateTime.new(2014,12,1).strftime("%Y%m%d-%H%M%S")
    str += '-'
    str += self.id.to_s.rjust(8, '0')
    self.reference_number = str
  end

  def status_name
    STATUSES[status].to_s
  end

  def krw_billing params
    process all_krw_price, params[:allat_enc_data], params[:allat_test_yn], AT_KRW_SHOP_ID
  end

  def all_krw_price
    at_amt = 0
    self.orders.where(deleted: false).each do |o|
      at_amt += o.total_price.to_i * o.quantity.to_i
    end
    at_amt += get_delivery_fee
  end

  def get_delivery_fee
    total = 0
    items = Hash.new(0)
    if !User.current.nil? and User.current.country != "KR"
      User.current.orders.order("id DESC").each do |x|
        item = x.item
        box = item.box
        name = if !item.periodic? then box.path else "#{box.path}/#{x.order_periodic}" end
        items["#{name}"] += item.weight * x.quantity
      end
    end
    items.each do |x, y|
      if x.split("/").size > 1
        total += calucate_box_delivery y, x.split("/")[1].to_i
      else
        total += calucate_box_delivery y
      end
    end
    total.ceil
  end

  def calucate_box_delivery weight, month = 1
    country_code = Array.new(10)
    country_code[0] = %w[CN MO SG TW]
    country_code[1] = %w[JP VN]
    country_code[2] = %w[BN ID MY PH TH]
    country_code[3] = %w[AU IN NZ NF]
    country_code[4] = %w[CA MX PR US]
    country_code[5] = %w[AD BE DE IT ES ES CZ GB FR DE DE IT LI L1 LU ES MC NL GB PL SM GB SK ES SE CH GB VA GB]
    country_code[6] = %w[AX AT A2 DK FO FI GR GL IE M3 GR NO PT]
    country_code[7] = %w[AS AI AG AR AM AW AZ BS BH BD BB BZ BM BT BO BL BR VG BG KH KY CL CO CK CR HR CB CY DM DO EC EG SV ER FJ GF PF GI GD GP GU GT GG HT HN HU IS IQ JM JE KZ KI KO KW LA LV LT MV MT MH MQ FM MN MS NP AN NC NI MP OM PK PW PA PG PY PE PO QA RO RT RU SS SP WS SA SI SB ZA LK NT SW SX EU UV KN LC MB TB VL VC SR TA TJ TL TI TO ZZ TT TU TR TC TV VI UA VC AE UY UZ VU VE VR WF YA]
    country_code[8] = %w[AF AL DZ AO BY BJ BA BW BF BI CM CV CF TD KM CG CD CI DJ GQ EE ET GA GM GE GH GN GW GY IL JO KE KG RS LB LS LR LY MK MG MW ML MR MU YT MD ME MA MZ NA NE NG RE RW SN RS SC SL SZ SY TZ TG TN UG YE ZM ZW]
    country_code[9] = %w[SO HK]

    fee = Array.new(10)
    fee[0] = %w[32089.925 34536.425 36982.925 39429.425 41631.275 43629.25 45423.35 47135.9 48603.8 50153.25 51661.925 53089.05 54434.625 55780.2 57085 58389.8 59572.275 60917.85 62181.875 63405.125 64709.925 65933.175 67237.975 68502 69766.025 71030.05 72334.85 73598.875 74862.9 76126.925 77431.725 78695.75 79878.225 81183.025 82487.825 83425.65 84322.7 85219.75 86157.575 87013.85 88604.075 90765.15 92926.225 95087.3 97248.375 99409.45 101570.525 103731.6 105892.675 108053.75 110214.825 112375.9 114536.975 116698.05 118859.125 121020.2 123181.275 125342.35 127503.425 129664.5 131825.575 133986.65 136147.725 138308.8 140469.875 142630.95 144792.025 146953.1 149114.175 151275.25 153436.325 155597.4 157758.475 159919.55 162080.625 164241.7 166402.775 168563.85 170724.925 172886 175047.075 177208.15 179369.225 181530.3 183691.375 185852.45 188013.525 190174.6 192335.675 183487.5 185526.25 187565 189603.75 191642.5 193681.25 195720 197758.75 199797.5 201836.25 203875 205913.75 207952.5 209991.25 212030 214068.75 216107.5 218146.25 220185 222223.75 224262.5 226301.25 228340 230378.75 232417.5 234456.25 236495 238533.75 240572.5 242611.25 244650 246688.75 248727.5 250766.25 252805 254843.75 256882.5 258921.25 260960 262998.75 265037.5 267076.25 269115 271153.75 273192.5 275231.25 277270 279308.75 281347.5 283386.25 285425 287463.75 283712.45 285710.425 287708.4 289706.375 291704.35 293702.325 295700.3 297698.275 299696.25 301694.225 303692.2 305690.175 307688.15 309686.125 311684.1 313682.075 315680.05 317678.025 319676 321673.975 323671.95 325669.925 327667.9 329665.875 331663.85 333661.825 335659.8 337657.775 339655.75 341653.725 343651.7 345649.675 347647.65 349645.625 351643.6 353641.575 355639.55 357637.525 359635.5 361633.475 363631.45 365629.425 367627.4 369625.375 371623.35 373621.325 375619.3 377617.275 379615.25 381613.225 383611.2 385609.175 387607.15 389605.125 391603.1 393601.075 395599.05 397597.025 391440]
    fee[1] = %w[28064.85 30301.65 32328.75 34390.8 36417.9 38479.95 40507.05 42499.2 44561.25 46553.4 48825.15 50957.1 53193.9 55360.8 57597.6 59484.9 61407.15 63294.45 65146.8 67069.05 68432.1 69865.05 71193.15 72591.15 73989.15 75282.3 76680.3 77973.45 79336.5 80699.55 80944.2 81153.9 81503.4 81713.1 81957.75 82237.35 82447.05 82726.65 83006.25 83285.85 82394.625 84404.25 86413.875 88423.5 90433.125 92442.75 94452.375 96462 98471.625 100481.25 102490.875 104500.5 106510.125 108519.75 110529.375 112539 114548.625 116558.25 118567.875 120577.5 122587.125 124596.75 126606.375 128616 130625.625 132635.25 134644.875 136654.5 138664.125 140673.75 142683.375 144693 146702.625 148712.25 150721.875 152731.5 154741.125 156750.75 158760.375 160770 162779.625 164789.25 166798.875 168808.5 170818.125 172827.75 174837.375 176847 178856.625 166711.5 168563.85 170416.2 172268.55 174120.9 175973.25 177825.6 179677.95 181530.3 183382.65 185235 187087.35 188939.7 190792.05 192644.4 194496.75 196349.1 198201.45 200053.8 201906.15 203758.5 205610.85 207463.2 209315.55 211167.9 213020.25 214872.6 216724.95 218577.3 220429.65 222282 224134.35 225986.7 227839.05 229691.4 231543.75 233396.1 235248.45 237100.8 238953.15 240805.5 242657.85 244510.2 246362.55 248214.9 250067.25 251919.6 253771.95 255624.3 257476.65 259329 261181.35 258070.8 259888.2 261705.6 263523 265340.4 267157.8 268975.2 270792.6 272610 274427.4 276244.8 278062.2 279879.6 281697 283514.4 285331.8 287149.2 288966.6 290784 292601.4 294418.8 296236.2 298053.6 299871 301688.4 303505.8 305323.2 307140.6 308958 310775.4 312592.8 314410.2 316227.6 318045 319862.4 321679.8 323497.2 325314.6 327132 328949.4 330766.8 332584.2 334401.6 336219 338036.4 339853.8 341671.2 343488.6 345306 347123.4 348940.8 350758.2 352575.6 354393 356210.4 358027.8 359845.2 361662.6 356490]

    fee[2] = %w[35474.25 37920.75 40448.8 42895.3 45545.675 48236.825 50846.425 53537.575 56228.725 58919.875 61611.025 64261.4 66952.55 69602.925 72294.075 74699.8 77105.525 79511.25 81916.975 84363.475 86076.025 87829.35 89623.45 91376.775 93130.1 94598 96065.9 97533.8 99001.7 100469.6 100673.475 100999.675 101203.55 101407.425 101733.625 101855.95 101937.5 102141.375 102345.25 102549.125 101142.3875 103609.275 106076.1625 108543.05 111009.9375 113476.825 115943.7125 118410.6 120877.4875 123344.375 125811.2625 128278.15 130745.0375 133211.925 135678.8125 138145.7 140612.5875 143079.475 145546.3625 148013.25 150480.1375 152947.025 155413.9125 157880.8 160347.6875 162814.575 165281.4625 167748.35 170215.2375 172682.125 175149.0125 177615.9 180082.7875 182549.675 185016.5625 187483.45 189950.3375 192417.225 194884.1125 197351 199817.8875 202284.775 204751.6625 207218.55 209685.4375 212152.325 214619.2125 217086.1 219552.9875 212845.5 215210.45 217575.4 219940.35 222305.3 224670.25 227035.2 229400.15 231765.1 234130.05 236495 238859.95 241224.9 243589.85 245954.8 248319.75 250684.7 253049.65 255414.6 257779.55 260144.5 262509.45 264874.4 267239.35 269604.3 271969.25 274334.2 276699.15 279064.1 281429.05 283794 286158.95 288523.9 290888.85 293253.8 295618.75 297983.7 300348.65 302713.6 305078.55 307443.5 309808.45 312173.4 314538.35 316903.3 319268.25 321633.2 323998.15 326363.1 328728.05 331093 333457.95 332927.875 335272.4375 337617 339961.5625 342306.125 344650.6875 346995.25 349339.8125 351684.375 354028.9375 356373.5 358718.0625 361062.625 363407.1875 365751.75 368096.3125 370440.875 372785.4375 375130 377474.5625 379819.125 382163.6875 384508.25 386852.8125 389197.375 391541.9375 393886.5 396231.0625 398575.625 400920.1875 403264.75 405609.3125 407953.875 410298.4375 412643 414987.5625 417332.125 419676.6875 422021.25 424365.8125 426710.375 429054.9375 431399.5 433744.0625 436088.625 438433.1875 440777.75 443122.3125 445466.875 447811.4375 450156 452500.5625 454845.125 457189.6875 459534.25 461878.8125 464223.375 466567.9375 464835]

    fee[3] = %w[35148.05 38450.825 41672.05 44811.725 47910.625 51702.7 55576.325 59368.4 63201.25 67074.875 70051.45 72946.475 75923.05 78899.625 81876.2 84852.775 87788.575 90765.15 93741.725 96759.075 99124.025 101488.975 103976.25 106381.975 108869.25 111274.975 113762.25 116208.75 118696.025 121142.525 122202.675 123222.05 124363.75 125423.9 126402.5 127421.875 128359.7 129297.525 130276.125 131132.4 131234.3375 134435.175 137636.0125 140836.85 144037.6875 147238.525 150439.3625 153640.2 156841.0375 160041.875 163242.7125 166443.55 169644.3875 172845.225 176046.0625 179246.9 182447.7375 185648.575 188849.4125 192050.25 195251.0875 198451.925 201652.7625 204853.6 208054.4375 211255.275 214456.1125 217656.95 220857.7875 224058.625 227259.4625 230460.3 233661.1375 236861.975 240062.8125 243263.65 246464.4875 249665.325 252866.1625 256067 259267.8375 262468.675 265669.5125 268870.35 272071.1875 275272.025 278472.8625 281673.7 284874.5375 286240.5 289420.95 292601.4 295781.85 298962.3 302142.75 305323.2 308503.65 311684.1 314864.55 318045 321225.45 324405.9 327586.35 330766.8 333947.25 337127.7 340308.15 343488.6 346669.05 349849.5 353029.95 356210.4 359390.85 362571.3 365751.75 368932.2 372112.65 375293.1 378473.55 381654 384834.45 388014.9 391195.35 394375.8 397556.25 400736.7 403917.15 407097.6 410278.05 413458.5 416638.95 419819.4 422999.85 426180.3 429360.75 432541.2 435721.65 438902.1 442082.55 445263 448443.45 442938.825 446058.1125 449177.4 452296.6875 455415.975 458535.2625 461654.55 464773.8375 467893.125 471012.4125 474131.7 477250.9875 480370.275 483489.5625 486608.85 489728.1375 492847.425 495966.7125 499086 502205.2875 505324.575 508443.8625 511563.15 514682.4375 517801.725 520921.0125 524040.3 527159.5875 530278.875 533398.1625 536517.45 539636.7375 542756.025 545875.3125 548994.6 552113.8875 555233.175 558352.4625 561471.75 564591.0375 567710.325 570829.6125 573948.9 577068.1875 580187.475 583306.7625 586426.05 589545.3375 592664.625 595783.9125 598903.2 602022.4875 605141.775 608261.0625 611380.35 614499.6375 617618.925 620738.2125 615702.5] 

    fee[4] = %w[33394.725 36942.15 40285.7 43629.25 46972.8 50275.575 53252.15 56391.825 59490.725 62630.4 65729.3 68828.2 71845.55 74822.125 77798.7 80816.05 83711.075 86646.875 89623.45 92600.025 94801.875 97126.05 99409.45 101652.075 103976.25 106300.425 108543.05 110867.225 113150.625 115434.025 117676.65 119878.5 122121.125 124322.975 126647.15 128278.15 129949.925 131662.475 133334.25 135006.025 137085.55 140429.1 143772.65 147116.2 150459.75 153803.3 157146.85 160490.4 163833.95 167177.5 170521.05 173864.6 177208.15 180551.7 183895.25 187238.8 190582.35 193925.9 197269.45 200613 203956.55 207300.1 210643.65 213987.2 217330.75 220674.3 224017.85 227361.4 230704.95 234048.5 237392.05 240735.6 244079.15 247422.7 250766.25 254109.8 257453.35 260796.9 264140.45 267484 270827.55 274171.1 277514.65 280858.2 284201.75 287545.3 290888.85 294232.4 297575.95 275231.25 278289.375 281347.5 284405.625 287463.75 290521.875 293580 296638.125 299696.25 302754.375 305812.5 308870.625 311928.75 314986.875 318045 321103.125 324161.25 327219.375 330277.5 333335.625 336393.75 339451.875 342510 345568.125 348626.25 351684.375 354742.5 357800.625 360858.75 363916.875 366975 370033.125 373091.25 376149.375 379207.5 382265.625 385323.75 388381.875 391440 394498.125 397556.25 400614.375 403672.5 406730.625 409788.75 412846.875 415905 418963.125 422021.25 425079.375 428137.5 431195.625 431358.725 434396.4625 437434.2 440471.9375 443509.675 446547.4125 449585.15 452622.8875 455660.625 458698.3625 461736.1 464773.8375 467811.575 470849.3125 473887.05 476924.7875 479962.525 483000.2625 486038 489075.7375 492113.475 495151.2125 498188.95 501226.6875 504264.425 507302.1625 510339.9 513377.6375 516415.375 519453.1125 522490.85 525528.5875 528566.325 531604.0625 534641.8 537679.5375 540717.275 543755.0125 546792.75 549830.4875 552868.225 555905.9625 558943.7 561981.4375 565019.175 568056.9125 571094.65 574132.3875 577170.125 580207.8625 583245.6 586283.3375 589321.075 592358.8125 595396.55 598434.2875 601472.025 604509.7625 603470]

    fee[5] = %w[35963.55 41101.2 46198.075 51335.725 56514.15 61733.35 67115.65 72416.4 77676.375 82936.35 88359.425 93782.5 99287.125 104669.425 110133.275 114536.975 118899.9 123262.825 127625.75 131988.675 135821.525 139654.375 143487.225 147279.3 151030.6 154618.8 158166.225 161713.65 165301.85 168849.275 172315.15 175781.025 179246.9 182712.775 186178.65 189562.975 193069.625 196494.725 200001.375 203385.7 207300.1 212356.2 217412.3 222468.4 227524.5 232580.6 237636.7 242692.8 247748.9 252805 257861.1 262917.2 267973.3 273029.4 278085.5 283141.6 288197.7 293253.8 298309.9 303366 308422.1 313478.2 318534.3 323590.4 328646.5 333702.6 338758.7 343814.8 348870.9 353927 358983.1 364039.2 369095.3 374151.4 379207.5 384263.6 389319.7 394375.8 399431.9 404488 409544.1 414600.2 419656.3 424712.4 429768.5 434824.6 439880.7 444936.8 449992.9 442204.875 447118.2625 452031.65 456945.0375 461858.425 466771.8125 471685.2 476598.5875 481511.975 486425.3625 491338.75 496252.1375 501165.525 506078.9125 510992.3 515905.6875 520819.075 525732.4625 530645.85 535559.2375 540472.625 545386.0125 550299.4 555212.7875 560126.175 565039.5625 569952.95 574866.3375 579779.725 584693.1125 589606.5 594519.8875 599433.275 604346.6625 609260.05 614173.4375 619086.825 624000.2125 628913.6 633826.9875 638740.375 643653.7625 648567.15 653480.5375 658393.925 663307.3125 668220.7 673134.0875 678047.475 682960.8625 687874.25 692787.6375 691910.975 696783.5875 701656.2 706528.8125 711401.425 716274.0375 721146.65 726019.2625 730891.875 735764.4875 740637.1 745509.7125 750382.325 755254.9375 760127.55 765000.1625 769872.775 774745.3875 779618 784490.6125 789363.225 794235.8375 799108.45 803981.0625 808853.675 813726.2875 818598.9 823471.5125 828344.125 833216.7375 838089.35 842961.9625 847834.575 852707.1875 857579.8 862452.4125 867325.025 872197.6375 877070.25 881942.8625 886815.475 891688.0875 896560.7 901433.3125 906305.925 911178.5375 916051.15 920923.7625 925796.375 930668.9875 935541.6 940414.2125 945286.825 950159.4375 955032.05 959904.6625 964777.275 969649.8875 962290]

    fee[6] = %w[38246.95 44322.425 50520.225 56554.925 62671.175 68053.475 73068.8 78043.35 83058.675 88074 93130.1 98226.975 103283.075 108379.95 113395.275 118981.45 124526.85 130031.475 135658.425 141163.05 146015.275 150908.275 155801.275 160735.05 165587.275 170480.275 175373.275 180347.825 185240.825 190174.6 192131.8 194048.225 196046.2 197962.625 199879.05 201795.475 203711.9 205628.325 207585.525 209583.5 211479.5375 216637.575 221795.6125 226953.65 232111.6875 237269.725 242427.7625 247585.8 252743.8375 257901.875 263059.9125 268217.95 273375.9875 278534.025 283692.0625 288850.1 294008.1375 299166.175 304324.2125 309482.25 314640.2875 319798.325 324956.3625 330114.4 335272.4375 340430.475 345588.5125 350746.55 355904.5875 361062.625 366220.6625 371378.7 376536.7375 381694.775 386852.8125 392010.85 397168.8875 402326.925 407484.9625 412643 417801.0375 422959.075 428117.1125 433275.15 438433.1875 443591.225 448749.2625 453907.3 459065.3375 447709.5 452684.05 457658.6 462633.15 467607.7 472582.25 477556.8 482531.35 487505.9 492480.45 497455 502429.55 507404.1 512378.65 517353.2 522327.75 527302.3 532276.85 537251.4 542225.95 547200.5 552175.05 557149.6 562124.15 567098.7 572073.25 577047.8 582022.35 586996.9 591971.45 596946 601920.55 606895.1 611869.65 616844.2 621818.75 626793.3 631767.85 636742.4 641716.95 646691.5 651666.05 656640.6 661615.15 666589.7 671564.25 676538.8 681513.35 686487.9 691462.45 696437 701411.55 700596.05 705529.825 710463.6 715397.375 720331.15 725264.925 730198.7 735132.475 740066.25 745000.025 749933.8 754867.575 759801.35 764735.125 769668.9 774602.675 779536.45 784470.225 789404 794337.775 799271.55 804205.325 809139.1 814072.875 819006.65 823940.425 828874.2 833807.975 838741.75 843675.525 848609.3 853543.075 858476.85 863410.625 868344.4 873278.175 878211.95 883145.725 888079.5 893013.275 897947.05 902880.825 907814.6 912748.375 917682.15 922615.925 927549.7 932483.475 937417.25 942351.025 947284.8 952218.575 957152.35 962086.125 967019.9 971953.675 976887.45 981821.225 982677.5]

    fee[7] = %w[50601.775 57859.725 65158.45 72538.725 79796.675 87462.375 95005.75 102508.35 110133.275 117717.425 126035.525 134394.4 142753.275 151030.6 159430.25 167177.5 174965.525 182794.325 190460.025 198288.825 205220.575 212152.325 219165.625 226097.375 233151.45 239308.475 245424.725 251500.2 257698 263855.025 270909.1 277922.4 284894.925 291908.225 298921.525 303325.225 307565.825 311928.75 316250.9 320532.275 321816.6875 329665.875 337515.0625 345364.25 353213.4375 361062.625 368911.8125 376761 384610.1875 392459.375 400308.5625 408157.75 416006.9375 423856.125 431705.3125 439554.5 447403.6875 455252.875 463102.0625 470951.25 478800.4375 486649.625 494498.8125 502348 510197.1875 518046.375 525895.5625 533744.75 541593.9375 549443.125 557292.3125 565141.5 572990.6875 580839.875 588689.0625 596538.25 604387.4375 612236.625 620085.8125 627935 635784.1875 643633.375 651482.5625 659331.75 667180.9375 675030.125 682879.3125 690728.5 698577.6875 680738.625 688302.3875 695866.15 703429.9125 710993.675 718557.4375 726121.2 733684.9625 741248.725 748812.4875 756376.25 763940.0125 771503.775 779067.5375 786631.3 794195.0625 801758.825 809322.5875 816886.35 824450.1125 832013.875 839577.6375 847141.4 854705.1625 862268.925 869832.6875 877396.45 884960.2125 892523.975 900087.7375 907651.5 915215.2625 922779.025 930342.7875 937906.55 945470.3125 953034.075 960597.8375 968161.6 975725.3625 983289.125 990852.8875 998416.65 1005980.4125 1013544.175 1021107.9375 1028671.7 1036235.4625 1043799.225 1051362.9875 1058926.75 1066490.5125 1068264.225 1075787.2125 1083310.2 1090833.1875 1098356.175 1105879.1625 1113402.15 1120925.1375 1128448.125 1135971.1125 1143494.1 1151017.0875 1158540.075 1166063.0625 1173586.05 1181109.0375 1188632.025 1196155.0125 1203678 1211200.9875 1218723.975 1226246.9625 1233769.95 1241292.9375 1248815.925 1256338.9125 1263861.9 1271384.8875 1278907.875 1286430.8625 1293953.85 1301476.8375 1308999.825 1316522.8125 1324045.8 1331568.7875 1339091.775 1346614.7625 1354137.75 1361660.7375 1369183.725 1376706.7125 1384229.7 1391752.6875 1399275.675 1406798.6625 1414321.65 1421844.6375 1429367.625 1436890.6125 1444413.6 1451936.5875 1459459.575 1466982.5625 1474505.55 1482028.5375 1489551.525 1497074.5125 1496442.5]

    fee[8] = %w[51172.625 60020.8 68950.525 77880.25 86728.425 94475.675 102222.925 109970.175 117676.65 125342.35 133130.375 140836.85 148584.1 156290.575 164078.6 170806.475 177656.675 184466.1 191316.3 198084.95 204812.825 211499.925 218227.8 224955.675 231642.775 238370.65 245098.525 251785.625 258431.95 265159.825 272988.625 280776.65 288523.9 296352.7 304059.175 307198.85 310256.975 313396.65 316495.55 319594.45 322652.575 330522.15 338391.725 346261.3 354130.875 362000.45 369870.025 377739.6 385609.175 393478.75 401348.325 409217.9 417087.475 424957.05 432826.625 440696.2 448565.775 456435.35 464304.925 472174.5 480044.075 487913.65 495783.225 503652.8 511522.375 519391.95 527261.525 535131.1 543000.675 550870.25 558739.825 566609.4 574478.975 582348.55 590218.125 598087.7 605957.275 613826.85 621696.425 629566 637435.575 645305.15 653174.725 661044.3 668913.875 676783.45 684653.025 692522.6 700392.175 695417.625 703144.4875 710871.35 718598.2125 726325.075 734051.9375 741778.8 749505.6625 757232.525 764959.3875 772686.25 780413.1125 788139.975 795866.8375 803593.7 811320.5625 819047.425 826774.2875 834501.15 842228.0125 849954.875 857681.7375 865408.6 873135.4625 880862.325 888589.1875 896316.05 904042.9125 911769.775 919496.6375 927223.5 934950.3625 942677.225 950404.0875 958130.95 965857.8125 973584.675 981311.5375 989038.4 996765.2625 1004492.125 1012218.9875 1019945.85 1027672.7125 1035399.575 1043126.4375 1050853.3 1058580.1625 1066307.025 1074033.8875 1081760.75 1089487.6125 1071159.25 1078702.625 1086246 1093789.375 1101332.75 1108876.125 1116419.5 1123962.875 1131506.25 1139049.625 1146593 1154136.375 1161679.75 1169223.125 1176766.5 1184309.875 1191853.25 1199396.625 1206940 1214483.375 1222026.75 1229570.125 1237113.5 1244656.875 1252200.25 1259743.625 1267287 1274830.375 1282373.75 1289917.125 1297460.5 1305003.875 1312547.25 1320090.625 1327634 1335177.375 1342720.75 1350264.125 1357807.5 1365350.875 1372894.25 1380437.625 1387981 1395524.375 1403067.75 1410611.125 1418154.5 1425697.875 1433241.25 1440784.625 1448328 1455871.375 1463414.75 1470958.125 1478501.5 1486044.875 1493588.25 1501131.625 1504597.5]

    fee[9] = %w[26457.15 28484.25 30476.4 32468.55 34285.95 35963.55 37396.5 38829.45 40052.7 41345.85 42534.15 43722.45 44840.85 45994.2 47042.7 48091.2 49104.75 50188.2 51201.75 52285.2 53333.7 54347.25 55430.7 56444.25 57527.7 58506.3 59624.7 60673.2 61686.75 62735.25 63783.75 64867.2 65845.8 66929.25 68012.7 68746.65 69480.6 70214.55 70948.5 72066.9 73796.925 75596.85 77396.775 79196.7 80996.625 82796.55 84596.475 86396.4 88196.325 89996.25 91796.175 93596.1 95396.025 97195.95 98995.875 100795.8 102595.725 104395.65 106195.575 107995.5 109795.425 111595.35 113395.275 115195.2 116995.125 118795.05 120594.975 122394.9 124194.825 125994.75 127794.675 129594.6 131394.525 133194.45 134994.375 136794.3 138594.225 140394.15 142194.075 143994 145793.925 147593.85 149393.775 151193.7 152993.625 154793.55 156593.475 158393.4 160193.325 150984 152661.6 154339.2 156016.8 157694.4 159372 161049.6 162727.2 164404.8 166082.4 167760 169437.6 171115.2 172792.8 174470.4 176148 177825.6 179503.2 181180.8 182858.4 184536 186213.6 187891.2 189568.8 191246.4 192924 194601.6 196279.2 197956.8 199634.4 201312 202989.6 204667.2 206344.8 208022.4 209700 211377.6 213055.2 214732.8 216410.4 218088 219765.6 221443.2 223120.8 224798.4 226476 228153.6 229831.2 231508.8 233186.4 234864 236541.6 235737.75 237397.875 239058 240718.125 242378.25 244038.375 245698.5 247358.625 249018.75 250678.875 252339 253999.125 255659.25 257319.375 258979.5 260639.625 262299.75 263959.875 265620 267280.125 268940.25 270600.375 272260.5 273920.625 275580.75 277240.875 278901 280561.125 282221.25 283881.375 285541.5 287201.625 288861.75 290521.875 292182 293842.125 295502.25 297162.375 298822.5 300482.625 302142.75 303802.875 305463 307123.125 308783.25 310443.375 312103.5 313763.625 315423.75 317083.875 318744 320404.125 322064.25 323724.375 325384.5 327044.625 328704.75 330364.875 328530]

    total_weight = 0
    my_country_code = User.current.country
    my_country_number = 9
    index = 0
    country_code.each do |x|
      my_country_number = index if x.include? my_country_code
      index += 1
    end
    array_posigion = (weight * 2).ceil - 1
    array_posigion = 100 if array_posigion > 100
    fee[my_country_number][array_posigion].to_f * month
  end

  def process allat_amt, allat_enc_data, allat_test_yn, at_shop_id
    at_amt = allat_amt
    at_data = "allat_shop_id=" + at_shop_id +
               "&allat_amt=" + at_amt.to_s +
               "&allat_enc_data=" + allat_enc_data +
               "&allat_cross_key=" + AT_CROSS_KEY
    at_txt = approvalReq(at_data, "SSL")
    replycd = getValue("reply_cd", at_txt) #결과코드
    replymsg = getValue("reply_msg", at_txt) #결과 메세지
    result = ""
    success_flag = allat_test_yn == "Y" ? "0001" : "0000"
    if replycd == success_flag
      order_no         = getValue("order_no",at_txt)
      amt              = getValue("amt",at_txt)
      pay_type         = getValue("pay_type",at_txt)
      approval_ymdhms  = getValue("approval_ymdhms",at_txt)
      seq_no           = getValue("seq_no",at_txt)
      approval_no      = getValue("approval_no",at_txt)
      card_id          = getValue("card_id",at_txt)
      card_nm          = getValue("card_nm",at_txt)
      sell_mm          = getValue("sell_mm",at_txt)
      zerofee_yn       = getValue("zerofee_yn",at_txt)
      cert_yn          = getValue("cert_yn",at_txt)
      contract_yn      = getValue("contract_yn",at_txt)
      save_amt         = getValue("save_amt",at_txt)
      bank_id          = getValue("bank_id",at_txt)
      bank_nm          = getValue("bank_nm",at_txt)
      cash_bill_no     = getValue("cash_bill_no",at_txt)
      escrow_yn        = getValue("escrow_yn",at_txt)
      account_no       = getValue("account_no",at_txt)
      account_nm       = getValue("account_nm",at_txt)
      income_acc_nm    = getValue("income_account_nm",at_txt)
      income_limit_ymd = getValue("income_limit_ymd",at_txt)
      income_expect_ymd= getValue("income_expect_ymd",at_txt)
      cash_yn          = getValue("cash_yn",at_txt)
      hp_id            = getValue("hp_id",at_txt)
      ticket_id        = getValue("ticket_id",at_txt)
      ticket_pay_type  = getValue("ticket_pay_type",at_txt)
      ticket_name      = getValue("ticket_nm",at_txt)

      result += "결과코드              : " + replycd + "\n"
      result += "결과메세지            : " + replymsg + "\n"
      result += "주문번호              : " + order_no + "\n"
      result += "승인금액              : " + amt + "\n"
      result += "지불수단              : " + pay_type + "\n"
      result += "승인일시              : " + approval_ymdhms + "\n"
      result += "거래일련번호          : " + seq_no + "\n"
      result += "에스크로 적용 여부    : " + escrow_yn + "\n"
      self.replycd = replycd
      self.replymsg = replymsg
      # reference number
      unless pay_type == "VBANK"
        self.set_reference_number 
      end
      # pay option
      self.pay_option = PAY_OPTIONS[pay_type]
      self.order_no = order_no
      self.amt = amt
      self.pay_type = "#{bank_nm} : #{account_no} (#{account_nm})" if pay_type == "VBANK"
      self.approval_ymdhms = approval_ymdhms
      self.seq_no = seq_no
      self.status = (pay_type == "VBANK") ? PURCHASE_PENDING : PURCHASE_PAID
      result += "=============== 신용 카드 ===============================\n"
      result += "승인번호              : " + approval_no + "\n"
      result += "카드ID                : " + card_id + "\n"
      result += "카드명                : " + card_nm + "\n"
      result += "할부개월              : " + sell_mm + "\n"
      result += "무이자여부            : " + zerofee_yn + "\n";   #무이자(Y),일시불(N
      result += "인증여부              : " + cert_yn + "\n";      #인증(Y),미인증(N
      result += "직가맹여부            : " + contract_yn + "\n";  #3자가맹점(Y),대표가맹점(N
      result += "세이브 결제 금액      : " + save_amt + "\n"
      result += "=============== 계좌 이체 / 가상계좌 ====================\n"
      result += "은행ID                : " + bank_id + "\n"
      result += "은행명                : " + bank_nm + "\n"
      result += "현금영수증 일련 번호  : " + cash_bill_no + "\n"
      result += "=============== 가상계좌 ================================\n"
      result += "계좌번호              : " + account_no + "\n"
      result += "입금계좌명            : " + income_acc_nm + "\n"
      result += "입금자명              : " + account_nm + "\n"
      result += "입금기한일            : " + income_limit_ymd + "\n"
      result += "입금예정일            : " + income_expect_ymd + "\n"
      result += "현금영수증신청 여부   : " + cash_yn + "\n"
      result += "=============== 휴대폰 결제 =============================\n"
      result += "이동통신사구분        : " + hp_id + "\n"
      result += "=============== 상품권 결제 =============================\n"
      result += "상품권 ID             : " + ticket_id + "\n"
      result += "상품권 이름           : " + ticket_name + "\n"
      result += "결제구분              : " + ticket_pay_type + "\n"
    else
      result += "결과코드  : " + replycd.inspect + "\n";
      result += "결과메세지: " + replymsg.inspect + "\n";
      self.replycd = replycd
      self.replymsg = replymsg
    end

    logger.info result

    ActiveRecord::Base.transaction do
      #ITEM QUANTITY
      self.orders.where(deleted: false).each do |x|
        i = x.item
        if i.limited == true
          i.quantity -= x.quantity
          if i.quantity >= 0
            i.save
          else
            #TODO : RAISE ERROR HERE
            return false
          end
        end

        x.order_option_items.each do |y|
          option_item = y.option_item
          if option_item.limited == true
            option_item.quantity -= x.quantity
            if option_item.quantity >= 0
              option_item.save
            else
              #TODO : RAISE ERROR HERE
              return false
            end
          end
        end
      end

      self.save
    end

    is_success = replycd == success_flag
    return {is_success: is_success, msg: replymsg}
  end
end
#  // 올앳 결제 서버와 통신 : ApprovalReq->통신함수, $at_txt->결과값
#  //----------------------------------------------------------------
#  // (올앳 결제 서버와 통신 후에 로그를 남기면, 통신에러시 빠른 원인파악이 가능합니다.)
#    [신용카드 전표출력 예제]
#
#    결제가 정상적으로 완료되면 아래의 소스를 이용하여, 고객에게 신용카드 전표를 보여줄 수 있습니다.
#    전표 출력시 상점아이디와 주문번호를 설정하시기 바랍니다.
#
#    var urls ="http://www.allatpay.com/servlet/AllatBizPop/member/pop_card_receipt.jsp?shop_id=상점아이디&order_no=주문번호";
#    window.open(urls,"app","width=410,height=650,scrollbars=0");
#
#    현금영수증 전표 또는 거래확인서 출력에 대한 문의는 올앳페이 사이트의 1:1상담을 이용하시거나
#    02) 3788-9990 으로 전화 주시기 바랍니다.
#
#    전표출력 페이지는 저희 올앳 홈페이지의 일부로써, 홈페이지 개편 등의 이유로 인하여 페이지 변경 또는 URL 변경이 있을 수
#    있습니다. 홈페이지 개편에 관한 공지가 있을 경우, 전표출력 URL을 확인하시기 바랍니다.
