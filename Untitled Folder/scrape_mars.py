import time
from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
from selenium import webdriver
import datetime as dt
import time

def init_browser():
   # @NOTE: Replace the path with your actual path to the chromedriver
   executable_path = {"executable_path": "chromedriver.exe"}
   return Browser("chrome", **executable_path, headless=False)

def scrape():
    browser = init_browser()
    mars = {}
    url = "https://mars.nasa.gov/news/?page=0&per_page=40&order=publish_date+desc%2Ccreated_at+desc&search=&category=19%2C165%2C184%2C204&blank_scope=Latest"
    browser.visit(url)
    html = browser.html
    soup = BeautifulSoup(html, "html.parser")
    news_title = soup.find('div', class_='content_title').text
    news_p = soup.find('div',class_='article_teaser_body').text

    mars[news_title] = news_title
    mars[news_p] = news_p

    executable_path = {"executable_path": "chromedriver"}
    browser = Browser("chrome", **executable_path, headless=False)
    url_image = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    browser.visit(url_image)
    browser.find_by_id("full_image").click()
    time.sleep(2)
    browser.find_link_by_partial_text("more info").click()
    time.sleep(2)
    html = browser.html
    img_soup = BeautifulSoup(html, "html.parser")
    img = img_soup.find("figure", class_="lede")
    img.a["href"]
    feat_img = f'https://www.jpl.nasa.gov{img.find("a")["href"]}'
    mars[feat_img] = feat_img
    executable_path = {"executable_path": "chromedriver"}
    browser = Browser("chrome", **executable_path, headless=False)
    url_weather = "https://twitter.com/marswxreport?lang=en" 
    browser.visit(url_weather)   
    browser.click_link_by_id("stream-item-tweet-1017925917065302016")
    html_weather = browser.html
    soup = BeautifulSoup(html_weather, "html.parser")
    time.sleep(5)
    mars_weather = soup.find("p", class_="TweetTextSize TweetTextSize--jumbo js-tweet-text tweet-text")
    time.sleep(5)
    #mars_weather = soup.find("p", class_="TweetTextSize TweetTextSize--jumbo js-tweet-text tweet-text").get_text()
    mars[mars_weather] = mars_weather
    urlmarsfacts = 'https://space-facts.com/mars/'
    mars_facts = pd.read_html(urlmarsfacts)
    mars_facts
    df = mars_facts[0]
    df.columns=['Description','Value']
    df.set_index('Description',inplace= True)
    html_df = df.to_html()
    html_df = df.to_html(classes = "table table-striped")
    html_df
    mars[html_df] = html_df
    url_hemisphere  = "https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars"
    browser.visit(url_hemisphere)
    html = browser.html 
    hemi_soup = BeautifulSoup(html, "html.parser")
    hemi_links = hemi_soup.find_all("a", class_="itemLink product-item")
    image_hemi_urls = {}
    for i in range(0, len(hemi_links), 2):
        browser.visit("https://astrogeology.usgs.gov" + hemi_links[i]["href"])
        time.sleep(2)
        html = browser.html    
        hemi_img_soup = BeautifulSoup(html, "html.parser")
    
        hemi_title = hemi_img_soup.find("h2", class_="title").text
    
        sample_button = browser.find_link_by_text("Sample").first
        image_hemi_urls[hemi_title] = sample_button["href"]
    
    return mars
   #return image_hemi_urls