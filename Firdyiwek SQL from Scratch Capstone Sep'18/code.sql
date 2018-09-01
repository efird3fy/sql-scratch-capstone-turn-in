query for renaming and joining

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp;

---------------------------------
query to count distinct campaigns (8)

SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;
 --------------------------------
query to count distinct sournces (6)

SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

---------------------------------
query to determine which source is used for each campaign

 
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

RESULTS: 
utm_campaign	utm_source
getting-to-know-cool-tshirts	nytimes
weekly-newsletter	email
ten-crazy-cool-tshirts-facts	buzzfeed
retargetting-campaign	email
retargetting-ad	facebook
interview-with-cool-tshirts-founder	medium
paid-search	google
cool-tshirts-search	google


---------------------------------------
query: What pages are on the CoolTShirts website?

 
SELECT DISTINCT page_name
FROM page_visits;
    
RESULTS: 
Query Results
page_name
1 - landing_page
2 - shopping_cart
3 - checkout
4 - purchase
 -------------------------------------
first touch query:

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
        pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp;

RESULTS: 5692 unique first touches by user_id

---------------------------------------------
query to group first touches by campaign ordered from greatest number to least number of first touches

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
 
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source,
ft_attr.utm_campaign,
COUNT(*)
FROM ft_attr
Group by 1, 2
Order by 3 Desc;


QUERY RESULTS:

Source			campaign				COUNT(*)
medium			interview-with-cool-tshirts-founder	622
nytimes			getting-to-know-cool-tshirts		612
buzzfeed		ten-crazy-cool-tshirts-facts		576
google			cool-tshirts-search			169

-------------------------------------
same as above subing last touch for first touch

WITH last_touch AS (
    SELECT user_id,
        MIN(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
 
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
lt_attr.utm_campaign,
COUNT(*)
FROM lt_attr
Group by 1, 2
Order by 3 Desc;

RESULTS:
Query Results
lt_attr.utm_source	lt_attr.utm_campaign			COUNT(*)
email			weekly-newsletter			447
facebook		retargetting-ad				443
email			retargetting-campaign			245
nytimes			getting-to-know-cool-tshirts		232
buzzfeed		ten-crazy-cool-tshirts-facts		190
medium			interview-with-cool-tshirts-founder	184
google			paid-search				178
google			cool-tshirts-search			60

-------------------------------
query to find # of distinct users who make purchases

SELECT COUNT (DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';

RESULTS:
COUNT (DISTINCT user_id)
361

-----------------------------

query to determine what number of last touches attributable to each campagin result in a purchase page visit

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  WHERE page_name = '4 - purchase'
    GROUP BY user_id),
 
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
lt_attr.utm_campaign,
COUNT(*)
FROM lt_attr
Group by 1, 2
Order by 3 Desc;

RESULTS:
lt_attr.utm_source	lt_attr.utm_campaign	COUNT(*)
email		weekly-newsletter			115
facebook	retargetting-ad				113
email		retargetting-campaign			54
google		paid-search				52
buzzfeed	ten-crazy-cool-tshirts-facts		9
nytimes		getting-to-know-cool-tshirts		9
medium		interview-with-cool-tshirts-founder	7
google		cool-tshirts-search			2