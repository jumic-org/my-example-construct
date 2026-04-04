import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as kms from 'aws-cdk-lib/aws-kms';

export interface MyConstructProps {
  readonly bucketName?: string;
}

export class MyExampleConstruct extends Construct {
  constructor(scope: Construct, id: string, props: MyConstructProps = {}) {
    super(scope, id);

    const key = new kms.Key(this, 'MyKey', {
      enableKeyRotation: true,
    })

    new s3.Bucket(this, 'MyBucket', {
      bucketName: props.bucketName,
      enforceSSL: true,
      encryption: s3.BucketEncryption.KMS,
      encryptionKey: key,
    });
  }
}
