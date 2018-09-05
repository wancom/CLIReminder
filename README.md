#  CLI Reminder Register
  
コマンドからMacのリマインダーに登録できます。  
リマインダーはデフォルトのリストに登録されます。  
システム標準のリマインダーを使うためパーミッションが必要です。  
  
This CLI program is reminder register for mac.   
The program adds reminder into default reminder list.  
The program needs reminder permission.  
  
## How To Setup
git clone https://github.com/wancom/CLIReminder  
cd CLIReminder/reminder  
swiftc -o remind main.swift  
sudo mv remind /usr/local/bin/  
  
## How To Use
remind [Reminder title] [Date(Optional)] [Time(Optional)]  
  
日付は年/月/日または月/日のように指定できます。  
時間は時:分のように指定できます。  
  
日付や時間は省略することができます。  
ただし時間だけの省略はできません。

日付だけを省略した場合は今日または明日の予定として登録します。  
また日付はtodayやtomorrowを使うことができます。  
  
日付と時間を省略した場合はリマインダーを登録した1時間後にセットします。  
  
Date format is year/month/date or month/date  
Time format is hour:minute  
  
You can use today and tomorrow as Date.  
  
### Example
- remind TaskA today 19:00
- remind TaskB tomorrow 12:00
- remind TaskC 2020/6/20 9:00
  
- remind TaskD 9:00
- remind TaskE
  
- remind "Happy New Year" 01/01 0:0
  
- remind "You can use space using \"" tomorrow 9:00
