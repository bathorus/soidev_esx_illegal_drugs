Config              = {}
Config.MarkerType   = -1
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 5.0, y = 5.0, z = 3.0}
Config.MarkerColor  = {r = 0, g = 255, b = 0}

Config.RequiredCopsCoke  = 1
Config.RequiredCopsMeth  = 1
Config.RequiredCopsWeed  = 0
Config.RequiredCopsOpium = 1

Config.TimeToFarmWeed     = 1  * 1000
Config.TimeToProcessWeed  = 2  * 1000
Config.TimeToSellWeed     = 1  * 1000

Config.TimeToFarmOpium    = 2  * 1000
Config.TimeToProcessOpium = 3  * 1000
Config.TimeToSellOpium    = 1  * 1000

Config.TimeToFarmCoke     = 3  * 1000
Config.TimeToProcessCoke  = 4  * 1000
Config.TimeToSellCoke     = 1  * 1000

Config.TimeToFarmMeth     = 4  * 1000
Config.TimeToProcessMeth  = 5  * 1000
Config.TimeToSellMeth     = 1  * 1000

Config.Locale = 'en'

Config.Zones = {
	CokeField =			{x=3559.49,  y=3672.23,  z=28.12},
	CokeProcessing =	{x=3557.59,  y=3663.47,  z=28.12},
	CokeDealer =		{x=1236.0,    y=-2912.9,    z=25.33},
	MethField =			{x=1389.7,  y=3603.48,  z=38.94},
	MethProcessing =	{x=1394.28,  y=3601.75,  z=38.94},
	MethDealer =		{x=7.981,     y=6469.067,   z=31.528},
	WeedField =			{x=2636.56,  y=4755.99,  z=34.28},
	WeedProcessing =	{x=2576.02,  y=4645.8,  z=34.0},
	WeedDealer =		{x = 85.58,   y= -1959.34,  z= 20.13},
	OpiumField =		{x=2433.804,  y=4969.196,   z=42.348},
	OpiumProcessing =	{x=2434.43,   y=4964.18,    z=42.348},
	OpiumDealer =		{x=-3155.608, y=1125.368,   z=20.858}
}

Config.Map = {
  {name="Coke Farm Entrance",    color=4, scale=0.8, id=501, x=3626.86,  y=3754.87,  z=28.52},
  {name="Coke Farm",             color=4, scale=0.8, id=501, x=3559.49,  y=3672.23,  z=28.12},
  {name="Coke Processing",       color=4, scale=0.8, id=501, x=3559.49,  y=3672.23,  z=28.12},
  {name="Coke Sales",            color=3, scale=0.8, id=501, x=1236.0,   y=-2912.9,  z=25.33},
  {name="Meth Farm Entrance",    color=6, scale=0.8, id=499, x=1386.659, y=3622.805, z=35.012},
  {name="Meth Sales",            color=3, scale=0.8, id=499, x=7.981,    y=6469.067, z=31.528},
  {name="Opium Farm Entrance",   color=6, scale=0.8, id=403, x=2433.804, y=4969.196, z=42.348},
  {name="Opium Farm",            color=6, scale=0.8, id=403, x=2433.804, y=4969.196, z=42.348},
  {name="Opium Processing",      color=6, scale=0.8, id=403, x=2434.43,  y=4964.18,  z=42.348},
  {name="Opium Sales",           color=3, scale=0.8, id=403, x=-3155.608,y=1125.368, z=20.858},
  {name="Weed Farm",             color=2, scale=0.8, id=140, x=2636.56,  y=4755.99,  z=34.28},
  {name="Weed Processing",       color=2, scale=0.8, id=140, x=2576.02,  y=4645.8,   z=34.0},
  {name="Weed Sales",            color=3, scale=0.8, id=140, x=85.58,    y=-1959.34, z=20.13}
}

Config.WeedPriceBase    = 25
Config.OpiumPriceBase   = 50
Config.CokePriceBase    = 100
Config.MethPriceBase    = 200
