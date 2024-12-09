# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_08_154747) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "application_errors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "message", null: false
    t.integer "level", default: 0, null: false
    t.text "calling_function"
    t.text "backtrace"
    t.text "url"
    t.text "user_id"
    t.text "user_ip"
    t.text "user_agent"
    t.boolean "is_resolved"
    t.datetime "resolved_at"
    t.text "notes"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_languages_on_code", unique: true
    t.index ["name"], name: "index_languages_on_name", unique: true
  end

  create_table "passage_topics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "passage_id", null: false
    t.uuid "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["passage_id", "topic_id"], name: "index_passage_topics_on_passage_id_and_topic_id", unique: true
    t.index ["passage_id"], name: "index_passage_topics_on_passage_id"
    t.index ["topic_id"], name: "index_passage_topics_on_topic_id"
  end

  create_table "passages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title", default: ""
    t.integer "difficulty", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.string "stripe_price_id", limit: 128
    t.string "name", limit: 128, null: false
    t.integer "price", default: 0, null: false
    t.boolean "is_active", default: true, null: false
    t.integer "interval", null: false
    t.string "description"
    t.string "lookup_key", limit: 128
    t.string "currency", default: "usd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lookup_key"], name: "index_product_prices_on_lookup_key", unique: true
    t.index ["product_id"], name: "index_product_prices_on_product_id"
    t.index ["stripe_price_id"], name: "index_product_prices_on_stripe_price_id", unique: true
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "stripe_product_id", limit: 128
    t.string "name", limit: 128, null: false
    t.string "description"
    t.boolean "for_subscription", default: true, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_product_id"], name: "index_products_on_stripe_product_id", unique: true
  end

  create_table "pronunciations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "word_id", null: false
    t.uuid "tts_voice_id", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tts_voice_id"], name: "index_pronunciations_on_tts_voice_id"
    t.index ["word_id", "tts_voice_id"], name: "index_pronunciations_on_word_id_and_tts_voice_id", unique: true
    t.index ["word_id"], name: "index_pronunciations_on_word_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "sentence_translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "sentence_id", null: false
    t.uuid "language_id", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_sentence_translations_on_language_id"
    t.index ["sentence_id", "language_id"], name: "index_sentence_translations_on_sentence_id_and_language_id", unique: true
    t.index ["sentence_id"], name: "index_sentence_translations_on_sentence_id"
  end

  create_table "sentences", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "language_id"
    t.uuid "passage_id"
    t.text "content", default: ""
    t.integer "order_idx", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_sentences_on_language_id"
    t.index ["passage_id"], name: "index_sentences_on_passage_id"
  end

  create_table "stripe_webhook_errors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "message"
    t.string "stripe_customer_id"
    t.json "event_object"
    t.string "event_type"
    t.boolean "is_resolved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_ticket_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "support_ticket_id", null: false
    t.uuid "user_id", null: false
    t.text "content", null: false
    t.text "recipient_email"
    t.boolean "internal", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["support_ticket_id"], name: "index_support_ticket_messages_on_support_ticket_id"
    t.index ["user_id"], name: "index_support_ticket_messages_on_user_id"
  end

  create_table "support_tickets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "author_email", null: false
    t.string "subject", null: false
    t.integer "status", default: 0, null: false
    t.integer "priority", default: 0, null: false
    t.text "content", null: false
    t.datetime "resolved_at"
    t.uuid "assigned_to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_support_tickets_on_assigned_to_id"
    t.index ["author_email"], name: "index_support_tickets_on_author_email"
    t.index ["priority"], name: "index_support_tickets_on_priority"
    t.index ["status"], name: "index_support_tickets_on_status"
    t.index ["user_id"], name: "index_support_tickets_on_user_id"
  end

  create_table "topics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name", null: false
    t.text "description", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_topics_on_name", unique: true
  end

  create_table "tts_voices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "accent"
    t.text "language_code", null: false
    t.integer "gender", default: 0, null: false
    t.text "name", null: false
    t.text "provider_id", null: false
    t.integer "provider", default: 0, null: false
    t.index ["language_code"], name: "index_tts_voices_on_language_code"
    t.index ["provider"], name: "index_tts_voices_on_provider"
    t.index ["provider_id", "provider"], name: "index_tts_voices_on_provider_id_and_provider", unique: true
  end

  create_table "user_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "user_subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "product_id"
    t.uuid "product_price_id"
    t.string "stripe_subscription_id", limit: 128
    t.string "status"
    t.bigint "current_period_start"
    t.bigint "current_period_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_user_subscriptions_on_product_id"
    t.index ["product_price_id"], name: "index_user_subscriptions_on_product_price_id"
    t.index ["stripe_subscription_id"], name: "index_user_subscriptions_on_stripe_subscription_id", unique: true
    t.index ["user_id"], name: "index_user_subscriptions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "stripe_customer_id"
    t.string "verification_token"
    t.datetime "verified_at"
    t.datetime "verified_requested_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", unique: true
  end

  create_table "words", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "language_id", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id", "text"], name: "index_words_on_language_id_and_text", unique: true
    t.index ["language_id"], name: "index_words_on_language_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "passage_topics", "passages"
  add_foreign_key "passage_topics", "topics"
  add_foreign_key "product_prices", "products"
  add_foreign_key "pronunciations", "tts_voices"
  add_foreign_key "pronunciations", "words"
  add_foreign_key "sentence_translations", "languages"
  add_foreign_key "sentence_translations", "sentences"
  add_foreign_key "sentences", "languages"
  add_foreign_key "sentences", "passages"
  add_foreign_key "support_ticket_messages", "support_tickets"
  add_foreign_key "support_ticket_messages", "users"
  add_foreign_key "support_tickets", "users"
  add_foreign_key "support_tickets", "users", column: "assigned_to_id"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_subscriptions", "product_prices"
  add_foreign_key "user_subscriptions", "products"
  add_foreign_key "user_subscriptions", "users"
  add_foreign_key "words", "languages"
end
