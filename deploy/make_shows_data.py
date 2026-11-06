import json,re,sys,urllib.request
URL="https://rest.bandsintown.com/artists/Pressgang%20Mutiny/events?app_id=js_www.pressgangmutiny.com&date=all"
d=json.load(urllib.request.urlopen(URL,timeout=30))
REG={"Ontario":"ON","08":"ON","Nova Scotia":"NS","New Brunswick":"NB","Quebec":"QC","Québec":"QC"}
def name(e):
  n=(e.get("title") or e["venue"]["name"] or "").strip()
  n=re.sub(r"^Pressgang Mutiny Live at ","",n,flags=re.I)
  return n
def place(v):
  c=(v.get("city") or "").strip().replace("Downtown Toronto","Toronto"); r=(v.get("region") or "").strip(); k=(v.get("country") or "").strip()
  r=REG.get(r,r)
  if k=="Canada": tail=r if (r.isalpha() and len(r)<=3) else "Canada"
  elif k=="United States": tail=r if r.isalpha() else "USA"
  elif k=="United Kingdom": tail="UK"
  else: tail=k
  return ", ".join(x for x in (c,tail) if x) or "Online"
out=[{"date":e["datetime"][:10],"name":name(e),"place":place(e["venue"]),"url":e["url"].split("?")[0]} for e in sorted(d,key=lambda e:e["datetime"],reverse=True)]
json.dump(out,open(sys.argv[1],"w"),indent=1,ensure_ascii=False)
print(len(out),"events")
