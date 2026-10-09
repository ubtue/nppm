ALTER TABLE benutzer ADD COLUMN Salt VARCHAR(255) AFTER EMail;
ALTER TABLE benutzer ADD COLUMN ResetToken VARCHAR(255) AFTER Password;
ALTER TABLE benutzer ADD COLUMN ResetTokenValidUntil datetime AFTER ResetToken;
