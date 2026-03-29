import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';

export interface MyConstructProps {
  readonly bucketName?: string;
}

export class MyExampleConstruct extends Construct {
  constructor(scope: Construct, id: string, props: MyConstructProps = {}) {
    super(scope, id);

    new s3.Bucket(this, 'MyBucket', {
      bucketName: props.bucketName,
      enforceSSL: true,
    });
  }
}
