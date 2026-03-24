-- public.qc_amazon_corporate_creation_v source

CREATE OR REPLACE VIEW public.qc_amazon_corporate_creation_v
AS SELECT t.id AS transaction_id,
        CASE
            WHEN f1.encrypt_value = true THEN encode(decrypt_iv(decode(f1.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f1.id, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f1.value
        END AS name,
        CASE
            WHEN f1.encrypt_value = true THEN encode(decrypt_iv(decode(f1.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f1.id::text, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f1.value
        END AS merchant,
    f3.value AS address_line1,
    f4.value AS address_line2,
    f5.value AS phone,
    concat(
        CASE
            WHEN f7.encrypt_value = true THEN encode(decrypt_iv(decode(f7.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f7.id::text, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f7.value
        END, ' ',
        CASE
            WHEN f8.encrypt_value = true THEN encode(decrypt_iv(decode(f8.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f8.id::text, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f8.value
        END) AS contact_salutation,
        CASE
            WHEN f7.encrypt_value = true THEN encode(decrypt_iv(decode(f7.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f7.id::text, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f7.value
        END AS first_name,
        CASE
            WHEN f8.encrypt_value = true THEN encode(decrypt_iv(decode(f8.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f8.id::text, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f8.value
        END AS last_name_initials,
        CASE
            WHEN f9.encrypt_value = true THEN encode(decrypt_iv(decode(f9.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f9.id::text, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f9.value
        END AS email,
        CASE
            WHEN f10.encrypt_value = true THEN encode(decrypt_iv(decode(f10.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f10.id::text, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f10.value
        END AS phone1,
    f11.value AS city,
    f12.value AS state,
    'INDIA'::text AS country,
    f14.value AS pin_code,
    f17.value AS area,
    f16.value AS designation
   FROM transaction t
     JOIN work_flow_data wfd ON wfd.transaction_id = t.id
     LEFT JOIN form_fill_data f1 ON f1.transaction_id = t.id AND f1.form_fill_metadata_id = 2139
     LEFT JOIN form_fill_data f3 ON f3.transaction_id = t.id AND f3.form_fill_metadata_id = 2146
     LEFT JOIN form_fill_data f4 ON f4.transaction_id = t.id AND f4.form_fill_metadata_id = 2147
     LEFT JOIN form_fill_data f5 ON f5.transaction_id = t.id AND f5.form_fill_metadata_id = 2145
     LEFT JOIN form_fill_data f7 ON f7.transaction_id = t.id AND f7.form_fill_metadata_id = 2142
     LEFT JOIN form_fill_data f8 ON f8.transaction_id = t.id AND f8.form_fill_metadata_id = 2143
     LEFT JOIN form_fill_data f9 ON f9.transaction_id = t.id AND f9.form_fill_metadata_id = 2144
     LEFT JOIN form_fill_data f10 ON f10.transaction_id = t.id AND f10.form_fill_metadata_id = 2145
     LEFT JOIN form_fill_data f11 ON f11.transaction_id = t.id AND f11.form_fill_metadata_id = 2150
     LEFT JOIN form_fill_data f12 ON f12.transaction_id = t.id AND f12.form_fill_metadata_id = 2151
     LEFT JOIN form_fill_data f14 ON f14.transaction_id = t.id AND f14.form_fill_metadata_id = 2149
     LEFT JOIN form_fill_data f16 ON f16.transaction_id = t.id AND f16.form_fill_metadata_id = 2297
     LEFT JOIN form_fill_data f17 ON f17.transaction_id = t.id AND f17.form_fill_metadata_id = 2148
  WHERE t.template_id = 39 AND wfd.status::text = 'ACCEPTED'::text AND t.attr4 IS NULL AND t.id <> 264636
  ORDER BY t.id DESC;