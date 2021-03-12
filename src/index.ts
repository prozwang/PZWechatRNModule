import { NativeModules } from 'react-native'
const { RNWechat } = NativeModules

export function registerApp(appId: string, universalLink: string): Promise<boolean> {
  return RNWechat.registerApp(appId, universalLink)
}

export function isWXAppInstalled(): Promise<boolean> {
  return RNWechat.isWXAppInstalled()
}

export function sendAuthRequest(): Promise<string> {
  return RNWechat.sendAuthRequest()
}

interface PayInfo {
  partnerId: string
  prepayId: string
  nonceStr: string
  timeStamp: number
  sign: string
  package: string
}

export function pay(info: PayInfo): Promise<string> {
  return RNWechat.pay(info)
}
