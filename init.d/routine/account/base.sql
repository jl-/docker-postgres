CREATE OR REPLACE FUNCTION create_account (
    username text
) RETURNS boolean AS $$
BEGIN
    INSERT INTO accounts(username) VALUES(username);
    RETURN true;
END;
$$ LANGUAGE plpgsql;
