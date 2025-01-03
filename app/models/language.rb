# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  code       :text
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_code  (code) UNIQUE
#  index_languages_on_name  (name) UNIQUE
#

class Language < ApplicationRecord
  ENGLISH = 'English'.freeze

  LANGUAGE_CODES = {
    'aa' => 'Afar',
    'ab' => 'Abkhazian',
    'ae' => 'Avestan',
    'af' => 'Afrikaans',
    'ak' => 'Akan',
    'am' => 'Amharic',
    'an' => 'Aragonese',
    'ar' => 'Arabic',
    'as' => 'Assamese',
    'av' => 'Avaric',
    'ay' => 'Aymara',
    'az' => 'Azerbaijani',
    'ba' => 'Bashkir',
    'be' => 'Belarusian',
    'bg' => 'Bulgarian',
    'bh' => 'Bihari languages',
    'bi' => 'Bislama',
    'bm' => 'Bambara',
    'bn' => 'Bengali',
    'bo' => 'Tibetan',
    'br' => 'Breton',
    'bs' => 'Bosnian',
    'ca' => 'Catalan',
    'ce' => 'Chechen',
    'ch' => 'Chamorro',
    'co' => 'Corsican',
    'zh-CN' => 'Mandarin',
    'cr' => 'Cree',
    'cs' => 'Czech',
    'cu' => 'Church Slavic',
    'cv' => 'Chuvash',
    'cy' => 'Welsh',
    'da' => 'Danish',
    'de' => 'German',
    'dv' => 'Divehi',
    'dz' => 'Dzongkha',
    'ee' => 'Ewe',
    'el' => 'Greek, Modern (1453–)',
    'en' => 'English',
    'eo' => 'Esperanto',
    'es-ES' => 'Spanish (Spain)',
    'es-419' => 'Spanish (Latin America)',
    'et' => 'Estonian',
    'eu' => 'Basque',
    'fa' => 'Persian',
    'ff' => 'Fulah',
    'fi' => 'Finnish',
    'fj' => 'Fijian',
    'fo' => 'Faroese',
    'fr' => 'French',
    'fy' => 'Western Frisian',
    'ga' => 'Irish',
    'gd' => 'Scottish Gaelic',
    'gl' => 'Galician',
    'gn' => 'Guarani',
    'gu' => 'Gujarati',
    'gv' => 'Manx',
    'ha' => 'Hausa',
    'he' => 'Hebrew',
    'hi' => 'Hindi',
    'ho' => 'Hiri Motu',
    'hr' => 'Croatian',
    'ht' => 'Haitian',
    'hu' => 'Hungarian',
    'hy' => 'Armenian',
    'hz' => 'Herero',
    'ia' => 'Interlingua',
    'id' => 'Indonesian',
    'ie' => 'Interlingue',
    'ig' => 'Igbo',
    'ii' => 'Sichuan Yi',
    'ik' => 'Inupiaq',
    'io' => 'Ido',
    'is' => 'Icelandic',
    'it' => 'Italian',
    'iu' => 'Inuktitut',
    'ja' => 'Japanese',
    'jv' => 'Javanese',
    'ka' => 'Georgian',
    'kg' => 'Kongo',
    'ki' => 'Kikuyu',
    'kj' => 'Kuanyama',
    'kk' => 'Kazakh',
    'kl' => 'Kalaallisut',
    'km' => 'Central Khmer',
    'kn' => 'Kannada',
    'ko' => 'Korean',
    'kr' => 'Kanuri',
    'ks' => 'Kashmiri',
    'ku' => 'Kurdish',
    'kv' => 'Komi',
    'kw' => 'Cornish',
    'ky' => 'Kirghiz',
    'la' => 'Latin',
    'lb' => 'Luxembourgish',
    'lg' => 'Ganda',
    'li' => 'Limburgan',
    'ln' => 'Lingala',
    'lo' => 'Lao',
    'lt' => 'Lithuanian',
    'lu' => 'Luba-Katanga',
    'lv' => 'Latvian',
    'mg' => 'Malagasy',
    'mh' => 'Marshallese',
    'mi' => 'Maori',
    'mk' => 'Macedonian',
    'ml' => 'Malayalam',
    'mn' => 'Mongolian',
    'mr' => 'Marathi',
    'ms' => 'Malay',
    'mt' => 'Maltese',
    'my' => 'Burmese',
    'na' => 'Nauru',
    'nb' => 'Norwegian Bokmål',
    'nd' => 'North Ndebele',
    'ne' => 'Nepali',
    'ng' => 'Ndonga',
    'nl' => 'Dutch',
    'nn' => 'Norwegian Nynorsk',
    'no' => 'Norwegian',
    'nr' => 'South Ndebele',
    'nv' => 'Navajo',
    'ny' => 'Chichewa',
    'oc' => 'Occitan',
    'oj' => 'Ojibwa',
    'om' => 'Oromo',
    'or' => 'Oriya',
    'os' => 'Ossetian',
    'pa' => 'Panjabi',
    'pi' => 'Pali',
    'pl' => 'Polish',
    'ps' => 'Pushto',
    'pt' => 'Portuguese',
    'qu' => 'Quechua',
    'rm' => 'Romansh',
    'rn' => 'Rundi',
    'ro' => 'Romanian',
    'ru' => 'Russian',
    'rw' => 'Kinyarwanda',
    'sa' => 'Sanskrit',
    'sc' => 'Sardinian',
    'sd' => 'Sindhi',
    'se' => 'Northern Sami',
    'sg' => 'Sango',
    'si' => 'Sinhala',
    'sk' => 'Slovak',
    'sl' => 'Slovenian',
    'sm' => 'Samoan',
    'sn' => 'Shona',
    'so' => 'Somali',
    'sq' => 'Albanian',
    'sr' => 'Serbian',
    'ss' => 'Swati',
    'st' => 'Southern Sotho',
    'su' => 'Sundanese',
    'sv' => 'Swedish',
    'sw' => 'Swahili',
    'ta' => 'Tamil',
    'te' => 'Telugu',
    'tg' => 'Tajik',
    'th' => 'Thai',
    'ti' => 'Tigrinya',
    'tk' => 'Turkmen',
    'tl' => 'Tagalog',
    'tn' => 'Tswana',
    'to' => 'Tonga',
    'tr' => 'Turkish',
    'ts' => 'Tsonga',
    'tt' => 'Tatar',
    'tw' => 'Twi',
    'ty' => 'Tahitian',
    'ug' => 'Uighur',
    'uk' => 'Ukrainian',
    'ur' => 'Urdu',
    'uz' => 'Uzbek',
    've' => 'Venda',
    'vi' => 'Vietnamese',
    'vo' => 'Volapük',
    'wa' => 'Walloon',
    'wo' => 'Wolof',
    'xh' => 'Xhosa',
    'yi' => 'Yiddish',
    'yo' => 'Yoruba',
    'zh-HK' => 'Cantonese',
    'za' => 'Zhuang',
    'zu' => 'Zulu'
  }.freeze

  LOCALE_COUNTRY_MAP = {
    'en'    => 'US',
    'es'    => 'ES',
    'ko'    => 'KR',
    'ja'    => 'JP',
    'hi'    => 'IN',
    'fr'    => 'FR',
    'it'    => 'IT',
    'pt'    => 'PT',
    'de'    => 'DE',
    'ru'    => 'RU',
    'zh-CN' => 'CN',
    'zh-HK' => 'HK',
    'vi'    => 'VN'
  }.freeze

  SUPPORTED_LANGUAGES = [['en', 'English'], ['es-ES', 'Spanish (Spain)'], ['es-419', 'Spanish (Latin America)'], ['ko', 'Korean'], ['ja', 'Japanese'], ['hi', 'Hindi'], ['fr', 'French'], ['it', 'Italian'], ['pt', 'Portuguese'], ['de', 'German'], ['ru', 'Russian'], ['zh-CN', 'Mandarin'], ['vi', 'Vietnamese'], ['zh-HK', 'Cantonese']].freeze

  has_many :sentences
  has_many :pronunciations

  validates :name, presence: true
  validates :code, presence: true, inclusion: { in: LANGUAGE_CODES.keys }

  scope :supported_languages, -> {
    where(code: SUPPORTED_LANGUAGES.map { |sl| sl[0] })
  }

  def self.english
    Language.find_by!(name: ENGLISH)
  end

  def language_name
    Constants::LANGUAGE_CODES[code]
  end
end
