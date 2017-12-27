{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.Text (Text)
import qualified Data.Text as T
import           Text.Megaparsec
import           Test.Hspec

import           Network.EV07S


sample1 :: Text
sample1 = T.pack $
     "!1,123456789012345;"
  ++ "!D,25/12/17,22:27:43,12.345678,1.234567,5,0,360000,102.9,95,0,11,0;"
  ++ "!D,25/12/17,20:59:43,12.345678,1.234567,5,0,130000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:02:43,12.345678,1.234567,5,0,130000,102.9,97,0,13,0;"
  ++ "!D,25/12/17,21:05:44,12.345678,1.234567,5,0,110000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:08:44,12.345678,1.234567,5,0,120000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:11:45,12.345678,1.234567,5,0,120000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:14:45,12.345678,1.234567,5,0,110000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:17:51,12.345678,1.234567,5,0,110000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:20:50,12.345678,1.234567,5,0,120000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:23:51,12.345678,1.234567,5,0,120000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:26:51,12.345678,1.234567,5,0,120000,102.9,97,0,13,0;"
  ++ "!D,25/12/17,22:27:43,12.345678,1.234567,5,0,160000,102.9,95,0,11,0;"
  ++ "!D,25/12/17,21:29:52,12.345678,1.234567,5,0,120000,102.9,100,0,13,0;"
  ++ "!D,25/12/17,21:32:52,12.345678,1.234567,5,0,120000,102.9,97,0,13,0;"
  ++ "!D,25/12/17,21:35:53,12.345678,1.234567,5,0,120000,102.9,97,0,13,0;"
  ++ "!D,25/12/17,21:38:53,12.345678,1.234567,5,0,120000,102.9,97,0,13,0;"
  ++ "!D,25/12/17,21:41:54,12.345678,1.234567,5,0,120000,102.9,97,0,13,0;"
  ++ "!D,25/12/17,21:44:55,12.345678,1.234567,5,0,110000,102.9,97,0,13,0;"
  ++ "!D,25/12/17,21:47:55,12.345678,1.234567,5,0,110000,102.9,94,0,13,0;"
  ++ "!D,25/12/17,21:50:56,12.345678,1.234567,5,0,130000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,21:53:56,12.345678,1.234567,5,0,120000,102.9,97,0,10,0;"
  ++ "!D,25/12/17,21:56:57,12.345678,1.234567,5,0,120000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,21:59:57,12.345678,1.234567,5,0,130000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:02:58,12.345678,1.234567,5,0,130000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:06:00,12.345678,1.234567,5,0,120000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:09:00,12.345678,1.234567,5,0,110000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:12:00,12.345678,1.234567,5,0,110000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:15:34,12.345678,1.234567,5,0,110000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:18:10,12.345678,1.234567,5,0,110000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:21:11,12.345678,1.234567,5,0,120000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:24:11,12.345678,1.234567,5,0,120000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:27:23,12.345678,1.234567,5,0,120000,102.9,96,0,10,0;"
  ++ "!D,25/12/17,22:27:43,12.345678,1.234567,5,0,160000,102.9,95,0,12,0;"
  ++ "!D,25/12/17,22:27:43,12.345678,1.234567,5,0,130000,102.9,96,0,12,0;"
  ++ "!5,19,V;"
  ++ "!5,20,V;"
  ++ "!5,19,V;"
  ++ "!D,25/12/17,22:27:43,12.345678,1.234567,5,0,130000,102.9,96,0,12,0;"
  ++ "!5,19,V;"
  ++ "!5,19,V;"
  ++ "!5,19,V;"
  ++ "!D,25/12/17,22:27:43,12.345678,1.234567,5,0,130000,102.9,96,0,12,0;"
  ++ "!5,19,V;"
  ++ "!5,19,V;"
  ++ "!5,19,V;"
  ++ "!D,25/12/17,22:27:43,12.345678,1.234567,5,0,130000,102.9,95,0,12,0;"
  ++ "!5,19,V;"
  ++ "!5,19,V;"
  ++ "!D,26/12/17,18:10:53,12.345679,1.234568,0,14,160000,85.1,62,6,13,0;"
  ++ "!D,26/12/17,18:13:54,12.345679,1.234568,106,320,160001,159.6,59,4,14,0;"
  ++ "!D,26/12/17,18:23:42,12.345679,1.234568,106,320,0d0000,159.6,53,0,13,0;"


main :: IO ()
main = hspec $ do
  describe "messagesParser" $ do
    it "parses a longer realistic protocol sample `sample1`" $ do
      let parsed = runParser (messagesParser <* eof) "sample1" sample1
      let expected =
            [ MessageIMEIMessage (IMEIMessage {iMEIMessageIMEI = "123456789012345"})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:27:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x360000, alarmMessage_3 = 102.9, alarmMessageBattery = 95, alarmMessage_4 = 0, alarmMessage_5 = 11, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 20:59:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:02:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 97, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:05:44 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:08:44 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:11:45 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:14:45 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:17:51 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:20:50 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:23:51 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:26:51 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 97, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:27:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x160000, alarmMessage_3 = 102.9, alarmMessageBattery = 95, alarmMessage_4 = 0, alarmMessage_5 = 11, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:29:52 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 100, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:32:52 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 97, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:35:53 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 97, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:38:53 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 97, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:41:54 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 97, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:44:55 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 97, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:47:55 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 94, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:50:56 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:53:56 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 97, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:56:57 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 21:59:57 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:02:58 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:06:00 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:09:00 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:12:00 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:15:34 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:18:10 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x110000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:21:11 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:24:11 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:27:23 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x120000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 10, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:27:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x160000, alarmMessage_3 = 102.9, alarmMessageBattery = 95, alarmMessage_4 = 0, alarmMessage_5 = 12, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:27:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 12, alarmMessage_6 = 0})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 20, unknown1Message_2 = 'V'})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:27:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 12, alarmMessage_6 = 0})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:27:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 96, alarmMessage_4 = 0, alarmMessage_5 = 12, alarmMessage_6 = 0})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-25 22:27:43 UTC", alarmMessageLocation = (12.345678,1.234567), alarmMessageSpeed = 5, alarmMessage_1 = 0, alarmMessage_2 = 0x130000, alarmMessage_3 = 102.9, alarmMessageBattery = 95, alarmMessage_4 = 0, alarmMessage_5 = 12, alarmMessage_6 = 0})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageUnknown1Message (Unknown1Message {unknown1Message_1 = 19, unknown1Message_2 = 'V'})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-26 18:10:53 UTC", alarmMessageLocation = (12.345679,1.234568), alarmMessageSpeed = 0, alarmMessage_1 = 14, alarmMessage_2 = 0x160000, alarmMessage_3 = 85.1, alarmMessageBattery = 62, alarmMessage_4 = 6, alarmMessage_5 = 13, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-26 18:13:54 UTC", alarmMessageLocation = (12.345679,1.234568), alarmMessageSpeed = 106, alarmMessage_1 = 320, alarmMessage_2 = 0x160001, alarmMessage_3 = 159.6, alarmMessageBattery = 59, alarmMessage_4 = 4, alarmMessage_5 = 14, alarmMessage_6 = 0})
            , MessageAlarmMessage (AlarmMessage {alarmMessageDate = read "2017-12-26 18:23:42 UTC", alarmMessageLocation = (12.345679,1.234568), alarmMessageSpeed = 106, alarmMessage_1 = 320, alarmMessage_2 = 0x0d0000, alarmMessage_3 = 159.6, alarmMessageBattery = 53, alarmMessage_4 = 0, alarmMessage_5 = 13, alarmMessage_6 = 0})
            ]

      parsed `shouldBe` Right expected
