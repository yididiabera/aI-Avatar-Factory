!(register-module! ../../metta)
!(import! &self metta:helper-media-asset)

; store a media asset;
!(asset-store (MediaAsset "asset-v001"
  (type "video/mp4")
  (created "2026-04-26T15:00:00Z")
  (creator "production-pipeline")
  (params (voice "ElevenLabs-Rachel") (avatar "HeyGen-01") (format "9:16"))
  (quality-score 0.87)
  (parent-brief "brief-001")
  (parent-script "script-001")
  (file-path "/assets/v001.mp4")
  (file-size 14200000)))

; Retrieve it by id. it must return the full atom
!(asset-get "asset-v001")

; search by type
!(asset-search-by-type "video/mp4")

; partial lineage: brief only (e.g. voice asset before script is bound)
!(asset-store (MediaAsset "asset-v002"
  (type "audio/mpeg")
  (created "2026-04-26T16:00:00Z")
  (creator "voice-stage")
  (params (voice "ElevenLabs-Rachel") (avatar none) (format none))
  (quality-score 0.91)
  (parent-brief "brief-001")
  (parent-script none)
  (file-path "/assets/v002.mp3")
  (file-size 3200000)))
; lineage for full asset
!(asset-lineage "asset-v001")
; lineage when parent-script is none
!(asset-lineage "asset-v002")