{-# LANGUAGE StrictData #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Network.EV07S where


import           Text.Megaparsec
import           Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L
import           Data.Text (Text)
import qualified Data.Text as T
import           Data.Time (UTCTime(..))
import           Data.Time.Calendar (fromGregorianValid)
import           Data.Time.Clock (secondsToDiffTime)
import           Data.Void (Void)


type Parser = Parsec Void Text
type ParserError = ParseError Char Void


data IMEIMessage = IMEIMessage
  { iMEIMessageIMEI :: Text
  } deriving (Eq, Ord, Show)


data AlarmMessage = AlarmMessage
  { alarmMessageDate :: UTCTime
  , alarmMessageLocation :: (Double, Double)
  , alarmMessageSpeed :: Int
  , alarmMessage_1 :: Int
  , alarmMessage_2 :: Int
  , alarmMessage_3 :: Double
  , alarmMessageBattery :: Int
  , alarmMessage_4 :: Int
  , alarmMessage_5 :: Int
  , alarmMessage_6 :: Int
  } deriving (Eq, Ord, Show)


data Unknown1Message = Unknown1Message
  { unknown1Message_1 :: Int
  , unknown1Message_2 :: Char
  } deriving (Eq, Ord, Show)


-- | Messages are terminated with `;` and each starts with `!`.
-- There is no space between messages.
data Message
  -- | IMEI message.
  --
  -- Example:
  --
  -- > !1,865472032242591;
  = MessageIMEIMessage IMEIMessage
  -- | Alarm message.
  --
  -- Example:
  --
  -- > !D,25/12/17,22:27:43,50.586384,7.216149,5,0,360000,102.9,95,0,11,0;
  | MessageAlarmMessage AlarmMessage
  -- | Message of unknown use.
  --
  -- Example:
  --
  -- > !5,19,V;
  | MessageUnknown1Message Unknown1Message
  -- | Anything we don't know about.
  | MessageUnknown Text
  deriving (Eq, Ord, Show)


semicolonTerminatedText :: Parser Text
semicolonTerminatedText = T.pack <$> manyTill anyChar (char ';')


skipComma :: Parser ()
skipComma = char ',' *> pure ()


messageParser :: Parser Message
messageParser = do
  tag <- char '!' *> anyChar
  skipComma
  case tag of
    '1' -> MessageIMEIMessage <$> (IMEIMessage <$> semicolonTerminatedText)
    'D' -> do
      alarmMessageDate :: UTCTime <- do
        dd <- L.decimal
        _ <- char '/'
        mm <- L.decimal
        _ <- char '/'
        yy <- L.decimal
        skipComma
        hours <- L.decimal
        _ <- char ':'
        minutes <- L.decimal
        _ <- char ':'
        seconds <- L.decimal
        parsedDay <- case fromGregorianValid (2000 + yy) mm dd of
          Nothing -> fail "Alarm message day doesn't parse"
          Just parsedDay -> pure parsedDay
        pure $ UTCTime
          { utctDay = parsedDay
          , utctDayTime = secondsToDiffTime (hours * 3600 + minutes * 60 + seconds)
          }
      skipComma
      alarmMessageLocation :: (Double, Double) <- do
        lat <- L.float
        skipComma
        lon <- L.float
        pure (lat, lon)
      skipComma
      alarmMessageSpeed :: Int <- L.decimal
      skipComma
      alarmMessage_1 :: Int <- L.decimal
      skipComma
      alarmMessage_2 :: Int <- L.decimal
      skipComma
      alarmMessage_3 :: Double <- L.float
      skipComma
      alarmMessageBattery :: Int <- L.decimal
      skipComma
      alarmMessage_4 :: Int <- L.decimal
      skipComma
      alarmMessage_5 :: Int <- L.decimal
      skipComma
      alarmMessage_6 :: Int <- L.decimal
      _ <- char ';'
      pure $ MessageAlarmMessage $ AlarmMessage{..}
    '5' -> (MessageUnknown1Message <$>) $ do
      a <- L.decimal
      skipComma
      b <- anyChar
      _ <- char ';'
      pure $ Unknown1Message a b
    _ -> MessageUnknown <$> semicolonTerminatedText


messagesParser :: Parser [Message]
messagesParser = some messageParser
