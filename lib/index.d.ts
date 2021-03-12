export declare function registerApp(appId: string, universalLink: string): Promise<boolean>;
export declare function isWXAppInstalled(): Promise<boolean>;
export declare function sendAuthRequest(): Promise<string>;
interface PayInfo {
    partnerId: string;
    prepayId: string;
    nonceStr: string;
    timeStamp: number;
    sign: string;
    package: string;
}
export declare function pay(info: PayInfo): Promise<string>;
export {};
