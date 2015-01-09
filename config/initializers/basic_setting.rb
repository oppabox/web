MAIN_BANR = "/images/top/1.jpg"
STAR_BANR = "/images/top/2.jpg"
DESIGN_BANR = "/images/top/3.jpg"
BEAUTY_BANR = "/images/top/4.jpg"
KITCHEN_BANR = "/images/top/5.jpg"
JEWELRY_BANR = "/images/top/6.jpg"
GRIENICH_BANR = "/images/top/7.jpg"

BASE_ITEM_IMAGE_LOCATION = "/images/items"

CURRENCY = 1100

#### purchase status
PURCHASE_ORDERING = 0
PURCHASE_PAID = 1
PURCHASE_PENDING = 2
PURCHASE_ON_DELIVERY = 3
PURCHASE_DONE = 4

STATUS_NAME = ["purchase_ordering", "purchase_paid", "purchase_pending", "purchase_on_delivery", "purchase_done"]

#### purchase type
PURCHASE_VBANK = 0
PURCHASE_ABANK = 1
PURCHASE_CARD = 2

PAY_OPTIONS = {
	"VBANK" => PURCHASE_VBANK,
	"ABANK" => PURCHASE_ABANK,
	"CARD" => PURCHASE_CARD
}


ALLAT_TEST_FLAG = "N"

## FOR EXIMBAY
EXIMBAY_VER = "180"
# for test
#EXIMBAY_SECRET_KEY = "289F40E6640124B2628640168C3C5464"
#EXIMBAY_MID = "1849705C64"
#EXIMBAY_URL = "https://www.test.eximbay.com/web/payment2.0/payment_real.do"
# for oppabox
EXIMBAY_SECRET_KEY = "359B6D089502F529C19950790AA40595"
EXIMBAY_MID = "17813B6595"
EXIMBAY_URL = "https://www.eximbay.com/web/payment2.0/payment_real.do"
EXIMBAY_MOBILE_URL = "https://www.eximbay.com/web/mpayment/payment_real.do"
