AND(
    NOT(ISBLANK(GTIN__c)),
    AND(NOT(ISPICKVAL(GTIN_Category_ID__c, 'Z3')), NOT(ISPICKVAL(GTIN_Category_ID__c, 'Z9')),
    NOT(ISPICKVAL(GTIN_Category_ID__c, 'Z2')), NOT(ISPICKVAL(GTIN_Category_ID__c, 'Z4'))),
    RIGHT(GTIN__c, 1) != (
    RIGHT(
    TEXT(10 - MOD(
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 1, 1)) * 3) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 2, 1))) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 3, 1)) * 3) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 4, 1))) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 5, 1)) * 3) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 6, 1))) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 7, 1)) * 3) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 8, 1))) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 9, 1)) * 3) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 10, 1))) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 11, 1)) * 3) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 12, 1))) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 13, 1)) * 3) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 14, 1))) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 15, 1)) * 3) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 16, 1))) +
    (VALUE(MID(LPAD(GTIN__c, 18, '0'), 17, 1)) * 3)
    , 10)),
    1
    )
    )
    )