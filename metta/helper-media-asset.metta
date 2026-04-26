; asset store 
(= (asset-store $atom)
   (add-atom &self $atom))

; asset get 
;; asset exists
(= (asset-get $id)
   (match &self
     (MediaAsset $id $type $created $creator $params
                 $quality $pbrief $pscript $path $size)
     (MediaAsset $id $type $created $creator $params
                 $quality $pbrief $pscript $path $size)))

; asset search
(= (asset-search-by-type $mime-type)
   (match &self
     (MediaAsset $id (type $mime-type) $created $creator $params
                 $quality $pbrief $pscript $path $size)
     $id))
