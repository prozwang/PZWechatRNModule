import { NativeModules } from 'react-native';
const { RNWechat } = NativeModules;
export function registerApp(appId, universalLink) {
    return RNWechat.registerApp(appId, universalLink);
}
export function isWXAppInstalled() {
    return RNWechat.isWXAppInstalled();
}
export function sendAuthRequest() {
    return RNWechat.sendAuthRequest();
}
export function pay(info) {
    return RNWechat.pay(info);
}
